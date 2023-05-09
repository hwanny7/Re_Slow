package com.ssafy.reslow.domain.chatting.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.chatting.entity.Chat;

@Repository
public interface ChatRepository extends JpaRepository<Chat, Long> {

}
