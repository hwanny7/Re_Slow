package com.ssafy.reslow.domain.chatting.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.chatting.entity.ChatRoom;

interface RoomIdMapping {
	Long getRoomId();
}

@Repository
public interface ChatRoomRepository extends MongoRepository<ChatRoom, Long> {
	List<ChatRoom> findByParticipantsContaining(Long userId);
}
