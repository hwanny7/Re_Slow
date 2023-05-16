package com.ssafy.reslow.domain.notice.dto;

import java.time.format.DateTimeFormatter;

import com.ssafy.reslow.domain.chatting.dto.MessageType;
import com.ssafy.reslow.domain.notice.entity.Notice;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class NoticeResponse {
	Long alertNo;
	String senderNickname;
	String title;
	String time;
	MessageType type;

	public static NoticeResponse of(Notice notice) {
		return NoticeResponse.builder()
			.alertNo(notice.getNo())
			.senderNickname(notice.getSender())
			.title(notice.getTitle())
			.time(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(notice.getAlertTime()))
			.type(notice.getType())
			.build();
	}
}
