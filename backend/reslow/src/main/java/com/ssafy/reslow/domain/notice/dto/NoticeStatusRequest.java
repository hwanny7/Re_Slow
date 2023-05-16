package com.ssafy.reslow.domain.notice.dto;

import com.ssafy.reslow.global.common.FCM.dto.MessageType;

import lombok.Getter;

@Getter
public class NoticeStatusRequest {
	MessageType type;
	boolean alert;
}
