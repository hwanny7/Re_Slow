package com.ssafy.reslow.domain.knowhow.dto;

import java.util.ArrayList;
import java.util.List;

import com.ssafy.reslow.domain.knowhow.entity.Knowhow;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowListResponse {
	Long knowhowNo;
	String writer;
	String profile;
	String title;
	List<String> pictureList;
	int pictureCnt;
	Long likeCnt;
	Long commentCnt;

	public static KnowhowListResponse of(Knowhow knowhow, Long likeCnt, Long commentCnt) {
		List<String> pictureList = new ArrayList<>();
		int pictureCnt = Math.min(4, knowhow.getKnowhowContents().size());
		for (int p = 0; p < pictureCnt; p++) {
			pictureList.add(knowhow.getKnowhowContents().get(p).getImage());
		}

		return KnowhowListResponse.builder()
			.knowhowNo(knowhow.getNo())
			.writer(knowhow.getMember().getNickname())
			.profile(knowhow.getMember().getProfilePic())
			.title(knowhow.getTitle())
			.pictureList(pictureList)
			.pictureCnt(pictureCnt)
			.likeCnt(likeCnt)
			.commentCnt(commentCnt)
			.build();
	}

	public void setLikeCnt(Long likeCnt) {
		this.likeCnt = likeCnt;
	}
}
