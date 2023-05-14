package com.ssafy.reslow.domain.chatting.dto;

import java.time.LocalDateTime;

import com.ssafy.reslow.domain.member.entity.Member;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ChatRoomList {
	String roomId;
	Long memberNo; // 상대방No
	String nickname;
	String profilePic;
	LocalDateTime dateTime;
	String lastMessage;

	public static ChatRoomList of(Member member, String roomId, LocalDateTime dateTime, String message) {
		return ChatRoomList.builder()
			.roomId(roomId)
			.memberNo(member.getNo())
			.nickname(member.getNickname())
			.dateTime(dateTime)
			.lastMessage(message)
			.build();
	}
}
