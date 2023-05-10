package com.ssafy.reslow.domain.chatting.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.messaging.simp.SimpMessagingTemplate;
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
	private final RedisTemplate<String, Object> redisTemplate;
	private final SimpMessagingTemplate messagingTemplate;

	public void sendMessage(ChatMessage chatMessage) {
		// Member receiver = memberRepository.findByNickname(chatMessage.getReceiver())
		// 	.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		// List<String> deviceList = deviceRepository.findByMember(receiver)
		// 	.orElseThrow(() -> new CustomException(CHATROOM_NOT_FOUND));

		if (isUserOnline(chatMessage.getReceiver())) {
			System.out.println("==== CharService로 들어와서 publish 날리기 직전! =====");
			chatPublisher.publish(chatMessage.getRoomId(), chatMessage);
		} else {
			// fcmService.sendNotification(chatMessage.getReceiver(), chatMessage.getMessage());
		}
	}

	private boolean isUserOnline(String username) {
		// Check if the user is online using some mechanism (e.g. Redis)
		return true;
	}

	public void subscribeToChatRoom(String roomId, Long memberNo) {
		// Redis Pub/Sub의 subscribe 메소드를 사용하여 채팅방(Room) 구독(subscribe)
		redisTemplate.execute(new RedisCallback<Void>() {
			@Override
			public Void doInRedis(RedisConnection connection) throws DataAccessException {
				connection.subscribe(new MessageListener() {
					@Override
					public void onMessage(Message message, byte[] pattern) {
						// Redis에서 수신한 메시지를 WebSocket 클라이언트에게 전송
						String messageJson = (String)redisTemplate.getValueSerializer().deserialize(message.getBody());
						messagingTemplate.convertAndSend("/sub/chat/room/" + roomId, messageJson);
					}
				}, roomId.getBytes());
				return null;
			}
		});
		System.out.println("====== ChatService에 들어와서 등록 완료~~~~~~~!! =====");
		// Redis Set에 해당 클라이언트의 no 추가
		redisTemplate.opsForSet().add(roomId, memberNo);
	}

}
