package com.ssafy.reslow.domain.chatting.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChatMessageRequest {
	private String roomId;
	private Long sender; // 보낸사람
	private String message; // 보낸 메시지
	private String dateTime; // 메시지 보낸 시각
	private MessageType type; // 메시지 타입
}
