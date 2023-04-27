package com.ssafy.reslow.domain.manager.dto;

import javax.validation.constraints.NotEmpty;

import lombok.Getter;

@Getter
public class ManagerSignUpRequest {

	@NotEmpty(message = "아이디는 필수 입력값입니다.")
	private String id;
	@NotEmpty(message = "비밀번호 입력은 필수 입니다.")
	private String password;
}
