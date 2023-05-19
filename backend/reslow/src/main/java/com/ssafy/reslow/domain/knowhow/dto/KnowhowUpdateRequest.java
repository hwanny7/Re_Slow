package com.ssafy.reslow.domain.knowhow.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowUpdateRequest {
	Long boardNo;
	Long categoryNo;
	String title;
	List<KnowhowUpdateContent> contentList;

	public static KnowhowUpdateRequest of(KnowhowUpdateRequest updateRequest) {
		return KnowhowUpdateRequest.builder().categoryNo(updateRequest.categoryNo).title(updateRequest.title).build();
	}
}
