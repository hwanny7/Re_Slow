package com.ssafy.reslow.global.common.dto;

import org.springframework.http.HttpStatus;

import com.ssafy.reslow.global.exception.ErrorCode;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
@AllArgsConstructor
public class ReissueResponse {

	private int state;
	private String result;
	private String message;
	private Object error;

	public static ReissueResponse reissue() {
		return ReissueResponse.builder()
			.state(HttpStatus.UNAUTHORIZED.value())
			.message(ErrorCode.ACCESS_TOKEN_EXPIRED.getMessage())
			.error("TOKEN-0001")
			.build();
	}
}
