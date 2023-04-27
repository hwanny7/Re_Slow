package com.ssafy.reslow.domain.knowhow.controller;

import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.knowhow.service.KnowhowService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("knowhows")
@RequiredArgsConstructor
public class KnowhowController {
	private final KnowhowService knowhowService;

	@PostMapping("/{knowhowNo}/like")
	public Map<String, Long> likeKnowhow(Authentication authentication, @PathVariable("knowhowNo") Long knowhowNo
	) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return knowhowService.likeKnowhow(memberNo, knowhowNo);
	}

	@DeleteMapping("/{knowhowNo}/like")
	public Map<String, Long> unlikeKnowhow(Authentication authentication, @PathVariable("knowhowNo") Long knowhowNo
	) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return knowhowService.unlikeKnowhow(memberNo, knowhowNo);
	}
}
