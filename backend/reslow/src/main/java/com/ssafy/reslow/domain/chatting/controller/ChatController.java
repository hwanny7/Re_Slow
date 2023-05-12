package com.ssafy.reslow.domain.chatting.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.ssafy.reslow.domain.chatting.dto.ChatMessageRequest;
import com.ssafy.reslow.domain.chatting.dto.ChatRoomList;
import com.ssafy.reslow.domain.chatting.dto.FcmRequest;
import com.ssafy.reslow.domain.chatting.entity.ChatMessage;
import com.ssafy.reslow.domain.chatting.repository.ChatMessageRepository;
import com.ssafy.reslow.domain.chatting.service.ChatService;
import com.ssafy.reslow.domain.chatting.service.ChatSubscriber;
import com.ssafy.reslow.domain.chatting.service.FirebaseCloudMessageService;
import com.ssafy.reslow.domain.member.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/chat")
public class ChatController {
	private final ChatMessageRepository chatMessageRepository;
	private final ChatService chatService;
	private final MemberService memberService;
	private final RedisMessageListenerContainer redisMessageListener;
	private final ChatSubscriber chatSubscriber;
	private Map<String, ChannelTopic> channels;
	private final FirebaseCloudMessageService firebaseCloudMessageService;

	@PostConstruct
	public void init() {
		channels = new HashMap<>();
	}

	@MessageMapping("/message")
	public void handleChatMessage(@Payload ChatMessageRequest chatMessage) {
		System.out.println("받은 메시지 확인!!!!!!!!!!!!" + chatMessage.getMessage());
		// mongoDB에 저장하기
		chatService.saveChatMessage(chatMessage);
		// 채팅 보내기
		chatService.sendMessage(chatMessage, channels.get(chatMessage.getRoomId()));
	}

	// 채팅방 목록확인
	@GetMapping("/roomList")
	public List<ChatRoomList> chatRoomList(Authentication authentication) {
		Long memberNo = Long.parseLong(authentication.getName());
		return chatService.giveChatRoomList(chatService.findRoom(memberNo));
	}

	@PostMapping("/addChatTest")
	public void aa(@RequestBody ChatMessage message) {
		ChatMessage room = ChatMessage.of(message.getRoomId(), message.getUser(), message.getContent(),
			message.getDateTime());
		chatMessageRepository.save(room);

	}

	// 채팅방 생성 - 토픽 생성, roomId 저장
	@PostMapping("/{roomId}")
	public Map<String, String> createChatRoom(@PathVariable String roomId, @RequestBody Map<String, Long> userList) {
		// roomId로 topic 등록
		ChannelTopic channel = new ChannelTopic(roomId);
		redisMessageListener.addMessageListener(chatSubscriber, channel);
		channels.put(roomId, channel);

		// roomId 저장
		chatService.saveChattingRoom(roomId, userList);

		HashMap<String, String> map = new HashMap<>();
		map.put("room", roomId);
		return map;
	}

	// 토픽 제거
	@DeleteMapping("/{roomId}")
	public void deleteTopic(@PathVariable String roomId) {
		ChannelTopic channel = channels.get(roomId);
		channels.remove(roomId);
		redisMessageListener.removeMessageListener(chatSubscriber, channel);
	}

	// 토픽 구독 - web socket에 들어왔을 때 (= 채팅방에 들어갔을 때)
	@PostMapping("/subscribe/{roomId}")
	public Map<String, String> subscribeChatRoom(@PathVariable String roomId, Authentication authentication) {
		Long memberNo = Long.parseLong(authentication.getName());
		// subscribe
		chatService.subscribeToChatRoom(roomId, memberNo);

		HashMap<String, String> map = new HashMap<>();
		map.put("msg", "ok");
		return map;
	}

	// FCM 토큰 등록
	@PostMapping("/fcm/token")
	public Map<String, String> registerUserToken(
		@RequestBody Map<String, String> token,
		Authentication authentication) {
		Long memberNo = Long.parseLong(authentication.getName());
		return memberService.addDeviceToken(memberNo, token.get("preToken"), token.get("newToken"));
	}

	// FCM 토큰 삭제
	@DeleteMapping("/fcm/token")
	public Map<String, String> deleterUserToken(
		@RequestBody Map<String, String> token,
		Authentication authentication) {
		Long memberNo = Long.parseLong(authentication.getName());
		return memberService.deleteDeviceToken(memberNo, token.get("token"));
	}

	@PostMapping("/api/fcm")
	public ResponseEntity pushMessage(@RequestBody FcmRequest requestDTO) throws IOException,
		FirebaseMessagingException {
		// firebaseCloudMessageService.makeMessage(
		firebaseCloudMessageService.sendMessageTo(
			requestDTO.getTargetToken(),
			requestDTO.getTitle(),
			requestDTO.getBody(),
			requestDTO.getRoomId());
		return ResponseEntity.ok().build();
	}

}
