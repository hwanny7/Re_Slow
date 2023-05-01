package com.ssafy.reslow.domain.knowhow.dto;

import java.util.List;

import com.ssafy.reslow.domain.knowhow.entity.Knowhow;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowList {
	String writer;
	String profile;
	String title;
	List<String> pictureList;
	int pictureCnt;
	Long likeCnt;
	Long commentCnt;

	public static KnowhowList ofEntity(Knowhow knowhow, List<String> pictureList, int pictureCnt, Long likeCnt,
		Long commentCnt) {
		return KnowhowList.builder()
			.writer(knowhow.getMember().getNickname())
			.profile(knowhow.getMember().getProfilePic())
			.title(knowhow.getTitle())
			.pictureList(pictureList)
			.pictureCnt(pictureCnt)
			.likeCnt(likeCnt)
			.commentCnt(commentCnt)
			.build();
	}
}
