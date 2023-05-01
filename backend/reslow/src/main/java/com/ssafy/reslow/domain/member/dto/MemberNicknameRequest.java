package com.ssafy.reslow.domain.member.dto;

import javax.validation.constraints.Pattern;

import lombok.Getter;

@Getter
public class MemberNicknameRequest {

	@Pattern(regexp = "^[a-zA-Z0-9가-힣]{2,16}$", message = "닉네임은 2~16자 영문 소문자나 한글 또는 숫자를 사용하세요.")
	private String nickname;
}
