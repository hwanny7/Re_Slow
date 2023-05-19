package com.ssafy.reslow.global.common.FCM.dto;

import com.ssafy.reslow.domain.chatting.dto.ChatMessageRequest;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Builder
@AllArgsConstructor
@Getter
public class ChatFcmMessage {
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
	public static class SendCommentOrderMessage {
		String targetToken;
		String title; // 글 제목
		String nickname; // 댓글 단 사람 닉네임
		String content; // 댓글 내용
		Long boardNo;
		MessageType type;

		public static SendCommentOrderMessage of(String token, String title, String content, Long boardNo,
			String senderNickname) {
			return SendCommentOrderMessage.builder()
				.targetToken(token)
				.title(title)
				.content(content)
				.nickname(senderNickname)
				.boardNo(boardNo)
				.type(MessageType.COMMENT)
				.build();
		}
	}
}
