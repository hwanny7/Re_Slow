package com.ssafy.reslow.domain.chatting.service;

import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.reslow.domain.chatting.dto.ChatMessageRequest;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChatSubscriber implements MessageListener {

	private final ObjectMapper objectMapper;
	private final RedisTemplate redisTemplate;
	private final SimpMessageSendingOperations messagingTemplate; // WebSocket 클라이언트들에게 메시지를 전송

	/**
	 * Redis에서 메시지가 발행(publish)되면 대기하고 있던 Redis subscriber가 해당 메시지를 받아 처리
	 */
	@Override
	public void onMessage(Message message, byte[] pattern) {
		try {
			// redis에서 발행된 데이터를 받아 deserialize
			String publishMessage = (String)redisTemplate.getStringSerializer().deserialize(message.getBody());
			// ChatMessage 객채로 맵핑
			ChatMessageRequest chatMessage = objectMapper.readValue(publishMessage, ChatMessageRequest.class);
			System.out.println("subscriber들에게 들어간 채팅 메시지: + " + chatMessage.getMessage());
			// Websocket subscriber들에게 채팅 메시지 Send
			messagingTemplate.convertAndSend("/sub/chat/room/" + chatMessage.getRoomId(), chatMessage);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}
}
