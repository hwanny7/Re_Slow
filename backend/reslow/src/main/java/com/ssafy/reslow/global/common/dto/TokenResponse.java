package com.ssafy.reslow.global.common.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Builder
@Getter
@Setter
@AllArgsConstructor
public class TokenResponse {

	private String grantType;
	private String accessToken;
	private String refreshToken;
	private Long refreshTokenExpirationTime;
	private boolean existAccount;
}
