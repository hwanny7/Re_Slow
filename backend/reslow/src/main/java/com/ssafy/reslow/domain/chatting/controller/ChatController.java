package com.ssafy.reslow.domain.chatting.controller;

import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;
import com.ssafy.reslow.domain.chatting.service.ChatService;
import com.ssafy.reslow.domain.chatting.service.ChatSubscriber;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("")
public class ChatController {
	private final ChatService service;
	private final RedisMessageListenerContainer redisMessageListener;
	private final ChatSubscriber chatSubscriber;

	@MessageMapping("/chat/message")
	public void handleChatMessage(@Payload ChatMessage chatMessage) {
		System.out.println("받은 메시지 확인!!!!!!!!!!!!" + chatMessage.getMessage());
		
		// roomId로 topic 등록
		ChannelTopic channel = new ChannelTopic(chatMessage.getRoomId());
		redisMessageListener.addMessageListener(chatSubscriber, channel);
		service.sendMessage(chatMessage);
	}
}
