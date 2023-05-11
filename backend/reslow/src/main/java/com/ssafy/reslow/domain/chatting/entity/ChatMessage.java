package com.ssafy.reslow.domain.chatting.entity;

import javax.persistence.Id;

import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Builder;
import lombok.Getter;

@Document("chatting") // Collection명
@Getter
@Builder
public class ChatMessage {

	@Id
	private String id;
	private String roomId; // 글번호No + /대화상대1No + /대화상대2No
	private String user;
	private String content;
	private String dateTime;

	public static ChatMessage of(String roomId, String user, String content, String dateTime) {
		return ChatMessage.builder()
			.roomId(roomId)
			.user(user)
			.content(content)
			.dateTime(dateTime)
			.build();
	}
}
