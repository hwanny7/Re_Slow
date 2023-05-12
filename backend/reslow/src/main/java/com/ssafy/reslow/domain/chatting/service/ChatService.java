package com.ssafy.reslow.domain.chatting.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.ssafy.reslow.domain.chatting.dto.ChatMessageRequest;
import com.ssafy.reslow.domain.chatting.dto.ChatRoomList;
import com.ssafy.reslow.domain.chatting.entity.ChatMessage;
import com.ssafy.reslow.domain.chatting.entity.ChatRoom;
import com.ssafy.reslow.domain.chatting.repository.ChatMessageRepository;
import com.ssafy.reslow.domain.chatting.repository.ChatRoomRepository;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.DeviceRepository;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.global.exception.ErrorCode;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatService {
	private final ChatRoomRepository chatRoomRepository;
	private final ChatMessageRepository chatMessageRepository;

	private final ChatPublisher chatPublisher;
	private final FcmService fcmService;
	private final DeviceRepository deviceRepository;
	private final MemberRepository memberRepository;
	private final RedisTemplate<String, Object> redisTemplate;
	private final SimpMessagingTemplate messagingTemplate;

	public void sendMessage(ChatMessageRequest chatMessage, ChannelTopic topic) {
		// Member receiver = memberRepository.findByNickname(chatMessage.getReceiver())
		// 	.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		// List<String> deviceList = deviceRepository.findByMember(receiver)
		// 	.orElseThrow(() -> new CustomException(CHATROOM_NOT_FOUND));

		if (true) {
			System.out.println("==== CharService로 들어와서 publish 날리기 직전! =====");
			chatPublisher.publish(topic, chatMessage);
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
		System.out.println("====== ChatService에 들어와서 subscribe 등록 완료~~~~~~~!! =====");
		// Redis Set에 해당 클라이언트의 no 추가
		redisTemplate.opsForSet().add(roomId, memberNo);
	}

	public Map<String, String> saveChatMessage(ChatMessageRequest chatMessage) {
		ChatMessage message = ChatMessage.of(chatMessage.getRoomId(), chatMessage.getSender(), chatMessage.getMessage(),
			chatMessage.getDateTime());
		chatMessageRepository.save(message);

		Map<String, String> map = new HashMap<>();
		map.put("sender", String.valueOf(chatMessage.getSender()));
		map.put("Message", chatMessage.getMessage());
		return map;
	}

	public void saveChattingRoom(String roomId, Map<String, Long> userList) {
		ChatRoom room = ChatRoom.of(roomId, userList.get("user1"), userList.get("user2"));
		chatRoomRepository.save(room);
	}

	public List<ChatRoom> findRoom(Long memberNo) {
		List<ChatRoom> roomList = chatRoomRepository.findByParticipantsContaining(memberNo);
		return roomList;
	}

	public List<ChatRoomList> giveChatRoomList(List<ChatRoom> roomList) {
		List<String> roomIdList = new ArrayList<>();
		roomList.forEach(chatRoom -> roomIdList.add(chatRoom.getRoomId()));

		List<ChatMessage> messageList = new ArrayList<>(
			chatMessageRepository.findByRoomId(
				roomIdList)); // mongoRepository 인터페이스는 수정 불가능한 List를 반환하므로 ArrayList로 변환했음
		// 최신순으로 정렬
		Collections.sort(messageList, Comparator.comparing(ChatMessage::getDateTime).reversed());

		List<ChatRoomList> chatRoomList = new ArrayList<>();
		messageList.forEach(chatMessage -> {
			Member member = memberRepository.findById(chatMessage.getUser()).orElseThrow(() -> new CustomException(
				ErrorCode.MEMBER_NOT_FOUND));
			ChatRoomList chatRoom = ChatRoomList.of(member, chatMessage.getRoomId(), chatMessage.getDateTime(),
				chatMessage.getContent());
			chatRoomList.add(chatRoom);
		});

		return chatRoomList;
	}
}
