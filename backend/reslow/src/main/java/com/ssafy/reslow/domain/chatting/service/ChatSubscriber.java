package com.ssafy.reslow.domain.chatting.service;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;

@Service
public class ChatSubscriber {
    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @PostConstruct
    public void init() {
        new Thread(() -> {
            RedisMessageListenerContainer container = new RedisMessageListenerContainer();
            container.setConnectionFactory(redisTemplate.getConnectionFactory());
            container.addMessageListener((message, bytes) -> {
                ChatMessage chatMessage = (ChatMessage) redisTemplate.getValueSerializer().deserialize(message.getBody());
                messagingTemplate.convertAndSendToUser(chatMessage.getReceiver(), "/queue/chat", chatMessage);
            }, new ChannelTopic("chat"));
            container.start();
        }).start();
    }

}
