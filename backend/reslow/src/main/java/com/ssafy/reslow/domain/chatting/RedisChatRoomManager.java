package com.ssafy.reslow.domain.chatting;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

@Component
public class RedisChatRoomManager {
	private final RedisTemplate<String, Object> redisTemplate;

	public RedisChatRoomManager(RedisTemplate<String, Object> redisTemplate) {
		this.redisTemplate = redisTemplate;
	}

	public String createChatRoom(String senderId, String receiverId) {
		String roomId = senderId + "-" + receiverId;
		redisTemplate.convertAndSend("create-chat-room", roomId);
		return roomId;
	}

	public void enterChatRoom(String roomId, String userId) {
		redisTemplate.convertAndSend("enter-chat-room", roomId + "-" + userId);
	}

	public void leaveChatRoom(String roomId, String userId) {
		redisTemplate.convertAndSend("leave-chat-room", roomId + "-" + userId);
	}
}
