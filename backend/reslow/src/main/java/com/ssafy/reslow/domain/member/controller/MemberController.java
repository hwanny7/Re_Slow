package com.ssafy.reslow.domain.member.controller;

import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.member.dto.MemberIdRequest;
import com.ssafy.reslow.domain.member.dto.MemberLoginRequest;
import com.ssafy.reslow.domain.member.dto.MemberSignUpRequest;
import com.ssafy.reslow.domain.member.service.MemberService;
import com.ssafy.reslow.global.common.dto.TokenResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@RequestMapping("/members")
@RestController
public class MemberController {

	private final MemberService memberService;

	@PostMapping
	public Map<String, Object> signUp(@RequestBody MemberSignUpRequest signUp) {
		return memberService.signUp(signUp);
	}

	@PostMapping("/login")
	public TokenResponse login(@Validated @RequestBody MemberLoginRequest login) {
		return memberService.login(login);
	}

	@PostMapping("/logout")
	public Map<String, Object> logout(Authentication authentication) {
		return memberService.logout(authentication);
	}

	@PostMapping("/id")
	public Map<String, Object> idDuplicate(@RequestBody MemberIdRequest id) {
		return memberService.idDuplicate(id);
	}
}
