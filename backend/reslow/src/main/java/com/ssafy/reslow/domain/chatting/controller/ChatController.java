package com.ssafy.reslow.domain.chatting.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;
import com.ssafy.reslow.domain.chatting.service.ChatService;
import com.ssafy.reslow.domain.chatting.service.ChatSubscriber;
import com.ssafy.reslow.domain.member.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("")
public class ChatController {
	private final ChatService chatService;
	private final MemberService memberService;
	private final RedisMessageListenerContainer redisMessageListener;
	private final ChatSubscriber chatSubscriber;

	@MessageMapping("/chat/message")
	public void handleChatMessage(@Payload ChatMessage chatMessage) {
		System.out.println("받은 메시지 확인!!!!!!!!!!!!" + chatMessage.getMessage());
		chatService.sendMessage(chatMessage);
	}

	@PostMapping("/chat/{roomId}")
	public Map<String, String> createChatRoom(@PathVariable String roomId) {
		// roomId로 topic 등록
		ChannelTopic channel = new ChannelTopic(roomId);
		redisMessageListener.addMessageListener(chatSubscriber, channel);

		HashMap<String, String> map = new HashMap<>();
		map.put("topic", "ok");
		return map;
	}

	@PostMapping("/chat/subscribe/{roomId}")
	public Map<String, String> subscribeChatRoom(@PathVariable String roomId, Authentication authentication) {
		Long memberNo = Long.parseLong(authentication.getName());
		// subscribe
		chatService.subscribeToChatRoom(roomId, memberNo);

		HashMap<String, String> map = new HashMap<>();
		map.put("msg", "ok");
		return map;
	}

	@GetMapping("/chat/memberNo")
	public Map<String, Long> getChattingMemberNo(Authentication authentication,
		@RequestParam("nickname") String nickname) {
		Long myNo = Long.parseLong(authentication.getName());
		Long otherNo = chatService.findOtherMemberNo(nickname);

		Map<String, Long> map = new HashMap<>();
		map.put("myNo", myNo);
		map.put("otherNo", otherNo);

		return map;
	}

	@PostMapping("/fcm/token")
	public Map<String, String> registerUserToken(@RequestBody String token, Authentication authentication) {
		Long memberNo = Long.parseLong(authentication.getName());

		return memberService.addDeviceToken(memberNo, token);
	}
}
