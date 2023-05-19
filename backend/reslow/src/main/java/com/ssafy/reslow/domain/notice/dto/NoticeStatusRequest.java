package com.ssafy.reslow.domain.notice.dto;

import java.util.List;

import com.ssafy.reslow.global.common.FCM.dto.MessageType;

import lombok.Getter;

@Getter
public class NoticeStatusRequest {
	List<MessageType> type;
	boolean alert;
}
