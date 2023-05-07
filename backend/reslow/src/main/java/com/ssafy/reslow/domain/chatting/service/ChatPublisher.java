package com.ssafy.reslow.domain.chatting.service;


import com.ssafy.reslow.domain.chatting.dto.ChatMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class ChatPublisher {
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    public void publish(ChatMessage chatMessage) {
        redisTemplate.convertAndSend("chat", chatMessage);
    }
}
