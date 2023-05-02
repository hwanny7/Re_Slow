package com.ssafy.reslow.domain.member.controller;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.validation.Errors;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.member.dto.MemberAccountRequest;
import com.ssafy.reslow.domain.member.dto.MemberAddressResponse;
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
			throw new ValidationCheckException(VALIDATION_CHECK);
		}
		return memberService.signUp(signUp);
	}

	@PostMapping("/login")
	public TokenResponse login(@Validated @RequestBody MemberLoginRequest login, Errors errors) {
		if (errors.hasErrors()) {
			throw new ValidationCheckException(VALIDATION_CHECK);
		}
		return memberService.login(login);
	}

	@PostMapping("/logout")
	public Map<String, String> logout(Authentication authentication) {
		return memberService.logout(authentication);
	}

	@PostMapping("/id")
	public Map<String, String> idDuplicate(@Validated @RequestBody MemberIdRequest id, Errors errors) {
		if (errors.hasErrors()) {
			throw new ValidationCheckException(VALIDATION_CHECK);
		}
		return memberService.idDuplicate(id);
	}

	@PostMapping("/nickname")
	public Map<String, String> nicknameDuplicate(@Validated @RequestBody MemberNicknameRequest nickname,
		Errors errors) {
		if (errors.hasErrors()) {
			throw new ValidationCheckException(VALIDATION_CHECK);
		}
		return memberService.nicknameDuplicate(nickname);
	}

	@PostMapping("/info")
	public MemberUpdateResponse updateUser(Authentication authentication,
		@RequestPart(value = "Update") MemberUpdateRequest request,
		@RequestPart(value = "file", required = false) MultipartFile file)
		throws IOException {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return memberService.updateUser(memberNo, request, file);
	}

	@GetMapping("/address")
	public MemberAddressResponse userAddress(Authentication authentication) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return memberService.userAddress(memberNo);
	}

	@PostMapping("/account")
	public Map<String, Long> registAccount(Authentication authentication, @RequestBody MemberAccountRequest request) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return memberService.registAccount(memberNo, request);
	}
}
