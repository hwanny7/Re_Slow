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
		private Data data;
	}

	@Builder
	@AllArgsConstructor
	@Getter
	public static class Notification {
		private String title;
		private String body;
		private String image;
	}

	@Builder
	@AllArgsConstructor
	@Getter
	public static class Data {
		private String roomId;
		private String senderNickname;
		private String senderProfilePic;
		private MessageType type;
	}

	@Builder
	@AllArgsConstructor
	@Getter
	public static class SendChatMessage {
		String targetToken;
		String title;
		String body;
		String roomId;
		MessageType type;

		public static SendChatMessage of(ChatMessageRequest request, String token) {
			return SendChatMessage.builder()
				.targetToken(token)
				.title(null)
				.body(request.getMessage())
				.roomId(request.getRoomId())
				.type(MessageType.CHATTING)
				.build();
		}
	}

	@Builder
	@AllArgsConstructor
	@Getter
	public static class SendCommentMessage {
		String targetToken;
		String title;
		String body;
		String knowhowNo;
		MessageType type;

		public static SendCommentMessage of(ChatMessageRequest request, String token) {
			return SendCommentMessage.builder()
				.targetToken(token)
				.title(null)
				.body(request.getMessage())
				.knowhowNo(request.getRoomId())
				.type(MessageType.CHATTING)
				.build();
		}
	}

}
