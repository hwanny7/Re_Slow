package com.ssafy.reslow.domain.knowhow.dto;

import java.util.ArrayList;
import java.util.List;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
public class KnowhowRecommendRequest {
	List<String> keywords;

	public static KnowhowRecommendRequest of(String keyword) {
		List<String> keywords = new ArrayList<>();
		keywords.add(keyword);

		return KnowhowRecommendRequest.builder().keywords(keywords).build();
	}
}
