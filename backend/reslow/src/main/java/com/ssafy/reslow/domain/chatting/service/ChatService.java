package com.ssafy.reslow.domain.chatting.service;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChatService {
    @Autowired
    private ChatPublisher chatPublisher;

    @Autowired
    private FcmService fcmService;

    public void sendMessage(ChatMessage chatMessage) {
        if (isUserOnline(chatMessage.getReceiver())) {
            chatPublisher.publish(chatMessage);
        } else {
            fcmService.sendNotification(chatMessage.getReceiver(), chatMessage.getMessage());
        }
    }

    private boolean isUserOnline(String username) {
        // Check if the user is online using some mechanism (e.g. Redis)
        return true;
    }
}
