package com.ssafy.reslow.domain.chatting.dto;

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
	String dateTime;
	String lastMessage;

	public static ChatRoomList of(Member receiver, String roomId, String dateTime, String message) {
		return ChatRoomList.builder()
			.roomId(roomId)
			.memberNo(receiver.getNo())
			.nickname(receiver.getNickname())
			.dateTime(dateTime)
			.lastMessage(message)
			.profilePic(receiver.getProfilePic())
			.build();
	}
}
