package com.ssafy.reslow.domain.knowhow.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowUpdateContent {
	Long knowhowNo;
	boolean imageChange;
	String content;
}
