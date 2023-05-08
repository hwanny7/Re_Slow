package com.ssafy.reslow.domain.chatting.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;

@Service
public class ChatService {
	@Autowired
	private ChatPublisher chatPublisher;

	@Autowired
	private FcmService fcmService;

	public void sendMessage(ChatMessage chatMessage) {
		if (isUserOnline(chatMessage.getReceiver())) {
			chatPublisher.publish("chat-" + chatMessage.getSender(), chatMessage);
		} else {
			fcmService.sendNotification(chatMessage.getReceiver(), chatMessage.getMessage());
		}
	}

	private boolean isUserOnline(String username) {
		// Check if the user is online using some mechanism (e.g. Redis)
		return true;
	}
}
