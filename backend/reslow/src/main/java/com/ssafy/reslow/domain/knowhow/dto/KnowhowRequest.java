package com.ssafy.reslow.domain.knowhow.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowRequest {
	Long categoryNo;
	String title;
	List<String> contentList;

	public static KnowhowRequest ofEntity(KnowhowUpdateRequest updateRequest) {
		return KnowhowRequest.builder().categoryNo(updateRequest.categoryNo).title(updateRequest.title).build();
	}
}
