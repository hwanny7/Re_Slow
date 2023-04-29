package com.ssafy.reslow.domain.member.dto;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Pattern;

import lombok.Getter;

@Getter
public class MemberSignUpRequest {

	@Pattern(regexp = "(?=.*[0-9])(?=.*[a-z]).{4,16}", message = "아이디는 4~16자 영문 소문자, 숫자를 사용하세요.")
	@NotEmpty(message = "아이디는 필수 입력값입니다.")
	private String id;
	@NotEmpty(message = "비밀번호 입력은 필수 입니다.")
	@Pattern(regexp = "(?=.*[0-9])(?=.*[a-z])(?=.*\\W)(?=\\S+$).{8,16}", message = "비밀번호는 8~16자 영문 소문자, 숫자, 특수문자를 사용하세요.")
	private String password;
	@Pattern(regexp = "(?=.*[0-9])(?=.*[a-z]).{2,16}", message = "닉네임은 2~16자 영문 소문자, 숫자를 사용하세요.")
	@NotEmpty(message = "닉네임은 필수 입력값입니다.")
	private String nickname;
}
