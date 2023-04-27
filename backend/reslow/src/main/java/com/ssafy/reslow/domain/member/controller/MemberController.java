package com.ssafy.reslow.domain.member.controller;

import java.io.IOException;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.validation.Errors;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.member.dto.MemberIdRequest;
import com.ssafy.reslow.domain.member.dto.MemberLoginRequest;
import com.ssafy.reslow.domain.member.dto.MemberNicknameRequest;
import com.ssafy.reslow.domain.member.dto.MemberSignUpRequest;
import com.ssafy.reslow.domain.member.dto.MemberUpdateRequest;
import com.ssafy.reslow.domain.member.dto.MemberUpdateResponse;
import com.ssafy.reslow.domain.member.service.MemberService;
import com.ssafy.reslow.global.common.dto.TokenResponse;
import com.ssafy.reslow.global.exception.ValidationCheckException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@RequestMapping("/members")
@RestController
public class MemberController {

	private final MemberService memberService;

	@PostMapping
	public Map<String, Object> signUp(@Validated @RequestBody MemberSignUpRequest signUp, Errors errors) {
		if (errors.hasErrors()) {
			throw new ValidationCheckException(errors);
		}
		return memberService.signUp(signUp);
	}

	@PostMapping("/login")
	public TokenResponse login(@Validated @RequestBody MemberLoginRequest login, Errors errors) {
		if (errors.hasErrors()) {
			throw new ValidationCheckException(errors);
		}
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

	@PostMapping("/nickname")
	public Map<String, Object> nicknameDuplicate(@RequestBody MemberNicknameRequest nickname) {
		return memberService.nicknameDuplicate(nickname);
	}

	@PostMapping("/info")
	public MemberUpdateResponse updateUser(Authentication authentication,
		@RequestPart(value = "Update") MemberUpdateRequest request,
		@RequestPart(value = "file", required = false) MultipartFile file)
		throws IOException {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		return memberService.updateUser(principal, request, file);
	}
}
