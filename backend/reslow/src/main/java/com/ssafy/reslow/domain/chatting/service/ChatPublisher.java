package com.ssafy.reslow.domain.chatting.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;

@Service
public class ChatPublisher {
	@Autowired
	private RedisTemplate<String, Object> redisTemplate;

	public void publish(String topic, ChatMessage chatMessage) {
		redisTemplate.convertAndSend("chat-room-" + topic, chatMessage);
	}
}
