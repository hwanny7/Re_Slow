package com.ssafy.reslow.domain.member.dto;

import javax.validation.constraints.Pattern;

import lombok.Getter;

@Getter
public class MemberNicknameRequest {

	@Pattern(regexp = ".{2,16}", message = "닉네임은 2~16자로 사용하세요.")
	private String nickname;
}
