package com.ssafy.reslow.domain.member.dto;

import javax.validation.constraints.Pattern;

import lombok.Getter;

@Getter
public class MemberIdRequest {
	@Pattern(regexp = "^[a-z0-9]{4,16}$", message = "아이디는 영어 소문자 혹은 숫자 4~16자로 사용하세요.")
	private String id;
}
