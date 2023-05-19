package com.ssafy.reslow.domain.notice.dto;

import java.time.format.DateTimeFormatter;

import com.ssafy.reslow.domain.notice.entity.Notice;
import com.ssafy.reslow.global.common.FCM.dto.MessageType;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class NoticeResponse {
	Long noticeNo;
	String senderNickname;
	String title;
	String time;
	MessageType type;

	public static NoticeResponse of(Notice notice) {
		return NoticeResponse.builder()
			.noticeNo(notice.getNo())
			.senderNickname(notice.getSender())
			.title(notice.getTitle())
			.time(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(notice.getAlertTime()))
			.type(notice.getType())
			.build();
	}
}
