package com.ssafy.reslow.domain.chatting.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;

import com.ssafy.reslow.domain.chatting.dto.ChatMessageRequest;
import com.ssafy.reslow.domain.chatting.service.ChatService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
public class ChatMessageController {
	private final ChatService chatService;

	@MessageMapping("/chat/message")
	public void handleChatMessage(@Payload ChatMessageRequest chatMessage) {
		System.out.println("받은 메시지 확인!!!!!!!!!!!!" + chatMessage.getMessage());
		// mongoDB에 저장하기
		// chatService.saveChatMessage(chatMessage);
		// 채팅 보내기
		// chatService.sendMessage(chatMessage, channels.get(chatMessage.getRoomId()));
	}
}
