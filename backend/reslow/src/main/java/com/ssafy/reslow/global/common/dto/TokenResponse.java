package com.ssafy.reslow.global.common.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
@AllArgsConstructor
public class TokenResponse {

	private String grantType;
	private String accessToken;
	private String refreshToken;
	private Long refreshTokenExpirationTime;
}
