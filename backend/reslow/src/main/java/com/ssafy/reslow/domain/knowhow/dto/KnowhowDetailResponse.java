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
	List<KnowhowContentDetail> contentList;

	public static KnowhowDetailResponse of(Knowhow knowhow, List<KnowhowContentDetail> detailList) {
		return KnowhowDetailResponse.builder()
			.knowhowNo(knowhow.getNo())
			.writer(knowhow.getMember().getNickname())
			.profilePic(knowhow.getMember().getProfilePic())
			.date(knowhow.getCreatedDate())
			.title(knowhow.getTitle())
			.contentList(detailList).build();
	}
}
