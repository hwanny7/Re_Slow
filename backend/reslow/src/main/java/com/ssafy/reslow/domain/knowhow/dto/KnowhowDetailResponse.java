package com.ssafy.reslow.domain.knowhow.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowDetailResponse {
	String writer;
	LocalDateTime date;
	String title;
	List<KnowhowContentDetail> contentList;
}
