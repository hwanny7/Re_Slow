package com.ssafy.reslow.domain.notice.dto;

import com.ssafy.reslow.domain.chatting.dto.MessageType;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class NoticeResponse {
	String senderNickname;
	String title;
	String time;
	MessageType type;

	public static NoticeResponse of(String senderNickname, String title, String time, MessageType type) {
		return NoticeResponse.builder().senderNickname(senderNickname).title(title).time(time).type(type).build();
	}
}
