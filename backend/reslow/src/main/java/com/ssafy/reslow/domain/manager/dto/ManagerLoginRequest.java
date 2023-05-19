package com.ssafy.reslow.domain.manager.dto;

import javax.validation.constraints.NotEmpty;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;

import lombok.Getter;

@Getter
public class ManagerLoginRequest {

	@NotEmpty(message = "아이디 입력은 필수 입니다.")
	private String id;
	@NotEmpty(message = "비밀번호 입력은 필수 입니다.")
	private String password;

	public UsernamePasswordAuthenticationToken toAuthentication() {
		return new UsernamePasswordAuthenticationToken(id, password);
	}
}
