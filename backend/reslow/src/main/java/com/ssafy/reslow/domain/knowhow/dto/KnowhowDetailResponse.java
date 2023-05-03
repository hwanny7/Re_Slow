package com.ssafy.reslow.domain.knowhow.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.ssafy.reslow.domain.knowhow.entity.Knowhow;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowDetailResponse {
	Long knowhowNo;
	String writer;
	String profilePic;
	LocalDateTime date;
	String title;
	boolean like;
	Long likeCnt;
	Long commentCnt;
	List<KnowhowContentDetail> contentList;

	public static KnowhowDetailResponse of(Knowhow knowhow, List<KnowhowContentDetail> detailList, boolean like,
		Long likeCnt) {
		return KnowhowDetailResponse.builder()
			.knowhowNo(knowhow.getNo())
			.writer(knowhow.getMember().getNickname())
			.profilePic(knowhow.getMember().getProfilePic())
			.date(knowhow.getCreatedDate())
			.title(knowhow.getTitle())
			.like(like)
			.likeCnt(likeCnt)
			.commentCnt((long)knowhow.getKnowhowComments().size())
			.contentList(detailList).build();
	}
}
