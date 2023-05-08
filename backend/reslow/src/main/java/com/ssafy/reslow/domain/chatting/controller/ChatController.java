package com.ssafy.reslow.domain.chatting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;
import com.ssafy.reslow.domain.chatting.service.ChatService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/")
public class ChatController {
	@Autowired
	private ChatService service;

	@MessageMapping("/chat")
	public void handleChatMessage(@Payload ChatMessage chatMessage) {
		// String memberNo = authentication.getName();
		// log.error("이 멤버의 번호는 : " + memberNo);
		service.sendMessage(chatMessage);
	}
}
