package com.ssafy.reslow.domain.chatting.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.chatting.entity.ChatRoom;

@Repository
public interface ChatRoomRepository extends MongoRepository<ChatRoom, Long> {
	List<ChatRoom> findByParticipantsContaining(Long userId);

	Optional<ChatRoom> findByRoomId(String roomId);

	boolean existsByRoomId(String roomId);
}
