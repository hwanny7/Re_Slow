package com.ssafy.reslow.domain.chatting.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Id;

import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Builder;
import lombok.Getter;

@Document("chattingRoom") // Collection명
@Getter
@Builder
public class ChatRoom {
	@Id
	private String id;
	String roomId;
	List<Long> participants;

	public static ChatRoom of(String roomId, Long user1, Long user2) {
		List<Long> participantList = new ArrayList<>();
		participantList.add(user1);
		participantList.add(user2);

		return ChatRoom.builder().roomId(roomId).participants(participantList).build();
	}
}
