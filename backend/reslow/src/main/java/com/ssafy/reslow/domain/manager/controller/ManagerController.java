package com.ssafy.reslow.domain.manager.controller;

import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.manager.dto.ManagerLoginRequest;
import com.ssafy.reslow.domain.manager.dto.ManagerSignUpRequest;
import com.ssafy.reslow.domain.manager.service.ManagerService;
import com.ssafy.reslow.global.common.dto.TokenResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@RequestMapping("/managers")
@RestController
public class ManagerController {

	private final ManagerService managerService;

	@PostMapping
	public Map<String, Object> signUp(@RequestBody ManagerSignUpRequest signUp) {
		return managerService.signUp(signUp);
	}

	@PostMapping("/login")
	public TokenResponse login(@Validated @RequestBody ManagerLoginRequest login) {
		return managerService.login(login);
	}

	@PostMapping("/logout")
	public Map<String, Object> logout(Authentication authentication) {
		return managerService.logout(authentication);
	}
}

