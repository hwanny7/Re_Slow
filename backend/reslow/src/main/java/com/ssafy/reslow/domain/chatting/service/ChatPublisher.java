package com.ssafy.reslow.domain.chatting.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.stereotype.Service;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;

@Service
public class ChatPublisher {
	@Autowired
	private RedisTemplate<String, Object> redisTemplate;

	public void publish(ChannelTopic topic, ChatMessage chatMessage) {
		System.out.println("==== publisher에 publish로 들어옴! ====");
		redisTemplate.convertAndSend(topic.getTopic(), chatMessage);
	}
}
