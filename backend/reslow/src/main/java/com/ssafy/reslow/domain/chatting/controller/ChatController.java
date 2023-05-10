package com.ssafy.reslow.domain.chatting.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;
import com.ssafy.reslow.domain.chatting.service.ChatService;
import com.ssafy.reslow.domain.chatting.service.ChatSubscriber;
import com.ssafy.reslow.domain.member.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/chat")
public class ChatController {
	private final ChatService chatService;
	private final MemberService memberService;
	private final RedisMessageListenerContainer redisMessageListener;
	private final ChatSubscriber chatSubscriber;
	private Map<String, ChannelTopic> channels;

	@PostConstruct
	public void init() {
		channels = new HashMap<>();
	}

	@MessageMapping("/message")
	public void handleChatMessage(@Payload ChatMessage chatMessage) {
		System.out.println("받은 메시지 확인!!!!!!!!!!!!" + chatMessage.getMessage());
		chatService.sendMessage(chatMessage, channels.get(chatMessage.getRoomId()));
	}

	// 토픽 생성
	@PostMapping("/{roomId}")
	public Map<String, String> createChatRoom(@PathVariable String roomId) {
		// roomId로 topic 등록
		ChannelTopic channel = new ChannelTopic(roomId);
		redisMessageListener.addMessageListener(chatSubscriber, channel);
		channels.put(roomId, channel);

		HashMap<String, String> map = new HashMap<>();
		map.put("topic", "ok");
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

	@PostMapping("/fcm/token")
	public Map<String, String> registerUserToken(@RequestBody Map<String, String> token,
		Authentication authentication) {
		Long memberNo = Long.parseLong(authentication.getName());
		return memberService.addDeviceToken(memberNo, token.get("token"));
	}
}
