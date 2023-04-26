package com.ssafy.reslow.domain.member.dto;

import javax.validation.constraints.NotEmpty;

import lombok.Getter;

@Getter
public class MemberSignUpRequest {

	@NotEmpty(message = "아이디는 필수 입력값입니다.")
	private String id;
	@NotEmpty(message = "비밀번호는 필수 입력값입니다.")
	private String password;
	@NotEmpty(message = "닉네임은 필수 입력값입니다.")
	private String nickname;
}
