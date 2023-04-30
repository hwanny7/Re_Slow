package com.ssafy.reslow.domain.member.dto;

import javax.validation.constraints.Pattern;

import lombok.Getter;

@Getter
public class MemberIdRequest {

	@Pattern(regexp = "(?=.*[0-9a-zㄱ-ㅎ가-힣]).{4,16}", message = "아이디는 4~16자 영문 소문자나 한글 또는 숫자를 사용하세요.")
	private String id;
}
