package com.ssafy.reslow.domain.chatting.service;

import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.reslow.domain.chatting.dto.ChatMessage;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChatSubscriber {

	private final ObjectMapper objectMapper;
	private final SimpMessageSendingOperations messagingTemplate;

	/**
	 * Redis에서 메시지가 발행(publish)되면 대기하고 있던 Redis subscriber가 해당 메시지를 받아 처리
	 */
	public void sendMessage(String message) {
		try {
			// ChatMessage 객채로 맵핑
			ChatMessage chatMessage = objectMapper.readValue(message, ChatMessage.class);
			// Websocket 구독자에게 채팅 메시지 Send
			messagingTemplate.convertAndSend("/sub/chat/" + chatMessage.getRoomId(), chatMessage);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}

}
