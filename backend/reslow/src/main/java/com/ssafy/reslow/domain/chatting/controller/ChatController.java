package com.ssafy.reslow.domain.chatting.controller;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;
import com.ssafy.reslow.domain.chatting.service.ChatPublisher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;

@Controller
public class ChatController {
    @Autowired
    private ChatPublisher chatPublisher;

    @MessageMapping("/chat")
    public void handleChatMessage(@Payload ChatMessage chatMessage) {
        chatPublisher.publish(chatMessage);
    }
}
