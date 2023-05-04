package com.ssafy.reslow.domain.knowhow.dto;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;

@Getter
public class KnowhowRecommendRequest {
	List<String> keywords;

	public KnowhowRecommendRequest(String keyword) {
		List<String> keywords = new ArrayList<>();
		keywords.add(keyword);

		this.keywords = keywords;
	}
}
