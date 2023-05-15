package com.ssafy.reslow.domain.chatting.controller;

import java.io.IOException;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.ssafy.reslow.domain.chatting.dto.ChatMessageRequest;
import com.ssafy.reslow.domain.chatting.service.ChatPublisher;
import com.ssafy.reslow.domain.chatting.service.ChatService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
public class ChatMessageController {
	private final ChatService chatService;
	private final ChatPublisher chatPublisher;

	@MessageMapping("/chat/message")
	public void handleChatMessage(@Payload ChatMessageRequest chatMessage) throws
		IOException,
		FirebaseMessagingException {
		System.out.println("받은 메시지 확인!!!!!!!!!!!!" + chatMessage.getMessage());
		// mongoDB에 저장하기
		chatService.saveChatMessage(chatMessage);

		chatService.sendMessage(chatMessage);
	}
}
