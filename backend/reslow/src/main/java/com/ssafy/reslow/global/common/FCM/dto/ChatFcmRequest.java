package com.ssafy.reslow.global.common.FCM.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ChatFcmRequest {
	private String title;
	private String body;
	private String roomId;
	private String targetToken;
	private MessageType type;
}
