package com.ssafy.reslow.domain.knowhow.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowContentDetail {
	Long order;
	Long knowhowNo;
	String image;
	String content;
}
