package com.ssafy.reslow.domain.chatting.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Builder
@AllArgsConstructor
@Getter
public class FcmMessage {
	private boolean validate_only;
	private Message message;

	@Builder
	@AllArgsConstructor
	@Getter
	public static class Message {
		private Notification notification;
		private String token;
		// private List<String> registration_tokens;
	}

	@Builder
	@AllArgsConstructor
	@Getter
	public static class Notification {
		private String title;
		private String body;
		private String roomId;
		private String image;
	}

}
