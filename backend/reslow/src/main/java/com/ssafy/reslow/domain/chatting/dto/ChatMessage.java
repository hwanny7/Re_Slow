package com.ssafy.reslow.domain.chatting.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChatMessage {
	private String roomId;
	private String sender; // 보낸사람
	private String receiver; // 받은사람
	private String message; // 보낸 메시지
}
