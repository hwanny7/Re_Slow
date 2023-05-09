package com.ssafy.reslow.domain.chatting.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.reslow.domain.chatting.dto.ChatMessage;
import com.ssafy.reslow.domain.member.repository.DeviceRepository;
import com.ssafy.reslow.domain.member.repository.MemberRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatService {
	@Autowired
	private ChatPublisher chatPublisher;

	@Autowired
	private FcmService fcmService;

	private final DeviceRepository deviceRepository;
	private final MemberRepository memberRepository;

	public void sendMessage(ChatMessage chatMessage) {
		// Member receiver = memberRepository.findByNickname(chatMessage.getReceiver())
		// 	.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		// List<String> deviceList = deviceRepository.findByMember(receiver)
		// 	.orElseThrow(() -> new CustomException(CHATROOM_NOT_FOUND));

		if (isUserOnline(chatMessage.getReceiver())) {
			chatPublisher.publish("chat-" + chatMessage.getSender(), chatMessage);
		} else {
			// fcmService.sendNotification(chatMessage.getReceiver(), chatMessage.getMessage());
		}
	}

	private boolean isUserOnline(String username) {
		// Check if the user is online using some mechanism (e.g. Redis)
		return true;
	}

	// // 채팅방 생성..! - redis hash에 저장하기
	// public ChatRoom createChatRoom(Member sender, Member receiver) {
	//
	// }
}
