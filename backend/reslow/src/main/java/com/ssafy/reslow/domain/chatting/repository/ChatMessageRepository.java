package com.ssafy.reslow.domain.chatting.repository;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.ssafy.reslow.domain.chatting.entity.ChatMessage;

public interface ChatMessageRepository extends MongoRepository<ChatMessage, String> {
}
