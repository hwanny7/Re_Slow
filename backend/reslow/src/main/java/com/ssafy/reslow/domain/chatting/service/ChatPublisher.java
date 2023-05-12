package com.ssafy.reslow.domain.chatting.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.stereotype.Service;

import com.ssafy.reslow.domain.chatting.dto.ChatMessageRequest;

@Service
public class ChatPublisher {
	@Autowired
	private RedisTemplate<String, Object> redisTemplate;

	public void publish(ChannelTopic topic, ChatMessageRequest chatMessage) {
		redisTemplate.convertAndSend(topic.getTopic(), chatMessage);
	}
}
