package com.ssafy.reslow.domain.chatting.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.ssafy.reslow.domain.chatting.dto.ChatRoomList;
import com.ssafy.reslow.domain.chatting.dto.FcmMessage;
import com.ssafy.reslow.domain.chatting.dto.FcmRequest;
import com.ssafy.reslow.domain.chatting.dto.MessageType;
import com.ssafy.reslow.domain.chatting.entity.ChatMessage;
import com.ssafy.reslow.domain.chatting.repository.ChatMessageRepository;
import com.ssafy.reslow.domain.chatting.service.ChatService;
import com.ssafy.reslow.domain.chatting.service.FirebaseCloudMessageService;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.member.service.MemberService;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.global.exception.ErrorCode;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/chat")
public class ChatController {
	private final MemberRepository memberRepository;
	private final ChatMessageRepository chatMessageRepository;
	private final ChatService chatService;
	private final MemberService memberService;
	private final FirebaseCloudMessageService firebaseCloudMessageService;

	// 채팅방 생성 - 토픽 생성, roomId 저장
	@PostMapping("/{roomId}")
	public Map<String, String> createChatRoom(@PathVariable String roomId, @RequestBody Map<String, Long> userList) {
		// roomId 저장
		chatService.createChattingRoom(roomId, userList);

		HashMap<String, String> map = new HashMap<>();
		map.put("room", roomId);
		return map;
	}

	// 채팅방 입장 = web socket에 들어왔을 때
	@PostMapping("/subscribe/{roomId}")
	public Map<String, String> subscribeChatRoom(@PathVariable String roomId, Authentication authentication) {
		Long memberNo = Long.parseLong(authentication.getName());
		// subscribe
		chatService.enterChattingRoom(roomId, memberNo);

		HashMap<String, String> map = new HashMap<>();
		map.put("msg", "ok");
		return map;
	}

	// 채팅방 목록확인
	@GetMapping("/roomList")
	public List<ChatRoomList> chatRoomList(Authentication authentication) {
		Long memberNo = Long.parseLong(authentication.getName());
		return chatService.giveChatRoomList(chatService.findRoom(memberNo), memberNo);
	}

	// 채팅방 내용확인
	@GetMapping("/detail/{roomId}")
	public Slice<ChatMessage> chatRoomDetail(Authentication authentication, @PathVariable String roomId,
		Pageable pageable) {
		Long memberNo = Long.parseLong(authentication.getName());
		return chatService.showChatDetail(memberNo, roomId, pageable);
	}

	@PostMapping("/addChatTest")
	public void aa(@RequestBody ChatMessage message) {
		ChatMessage room = ChatMessage.of(message.getRoomId(), message.getUser(), message.getContent(),
			message.getDateTime());
		chatMessageRepository.save(room);

	}

	// 채팅방 나가기
	@DeleteMapping("/{roomId}")
	public void deleteTopic(@PathVariable String roomId) {
		// redisMessageListener.removeMessageListener(chatSubscriber, channel);
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
	public ResponseEntity pushMessage(@RequestBody FcmRequest requestDTO, Authentication authentication) throws
		IOException,
		FirebaseMessagingException {

		Long memberNo = Long.parseLong(authentication.getName());
		Member member = memberRepository.findById(memberNo)
			.orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

		System.out.println("데이터는 안갈거니?????????????????");
		System.out.println(requestDTO.getRoomId());
		firebaseCloudMessageService.sendMessageTo(FcmMessage.SendMessage.builder()
			.targetToken(
				requestDTO.getTargetToken())
			.title(requestDTO.getTitle())
			.body(requestDTO.getBody())
			.type(MessageType.CHATTING)
			.roomId(
				requestDTO.getRoomId())
			.build(), member);
		return ResponseEntity.ok().build();
	}

	// 존재하는 채팅방인지 확인
	@GetMapping("/check/{roomId}")
	public Map<String, Boolean> checkRoomId(@PathVariable String roomId) {
		return chatService.checkRoomId(roomId);
	}
}
