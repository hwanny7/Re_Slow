package com.ssafy.reslow.domain.knowhow.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowComment;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowCommentResponse {
	private Long commentNo;
	private Long memberNo;
	private Long parentNo;
	private String profilePic;
	private String nickname;

	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "Asia/Seoul")
	private LocalDateTime datetime;
	private String content;
	private List<KnowhowCommentResponse> children;

	public static KnowhowCommentResponse of(KnowhowComment comment) {
		List<KnowhowCommentResponse> children = comment.getChildren()
			.stream()
			.map(KnowhowCommentResponse::of)
			.collect(Collectors.toList());

		return KnowhowCommentResponse.builder()
			.commentNo(comment.getNo())
			.memberNo(comment.getMember().getNo())
			.parentNo(comment.getParent() != null ? comment.getParent().getNo() : null)
			.profilePic(comment.getMember().getProfilePic())
			.nickname(comment.getMember().getNickname())
			.datetime(comment.getCreatedDate())
			.content(comment.getContent())
			.children(children != null && !children.isEmpty() ? children : null)
			.build();
	}

}
