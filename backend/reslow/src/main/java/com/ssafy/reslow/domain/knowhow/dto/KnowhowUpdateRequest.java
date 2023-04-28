package com.ssafy.reslow.domain.knowhow.dto;

import java.util.List;

import lombok.Getter;

@Getter
public class KnowhowUpdateRequest {
	Long boardNo;
	Long categoryNo;
	String title;
	List<String> contentList;
}
