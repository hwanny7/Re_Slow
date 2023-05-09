package com.ssafy.reslow.domain.chatting.entity;

import java.time.LocalDateTime;

import javax.persistence.Id;

import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;

@Document("event")
@Getter
public class ChatMessage {

	@Id
	private String roomId; // 글번호No + /대화상대1No + /대화상대2No
	private String user;
	private String content;
	private LocalDateTime date;
}
