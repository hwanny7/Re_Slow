package com.ssafy.reslow.domain.knowhow.dto;

import java.util.ArrayList;
import java.util.List;

import com.ssafy.reslow.domain.knowhow.entity.Knowhow;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowRecommendResponse {
	String title;
	Long knowhowNo;
	String writer;
	List<String> imageList;

	public static KnowhowRecommendResponse of(Knowhow knowhow) {
		List<String> imageList = new ArrayList<>();
		knowhow.getKnowhowContents().forEach(knowhowContent -> imageList.add(knowhowContent.getImage()));

		return KnowhowRecommendResponse.builder()
			.title(knowhow.getTitle())
			.knowhowNo(knowhow.getNo())
			.writer(knowhow.getMember().getNickname())
			.imageList(imageList)
			.build();
	}
}
