package com.ssafy.reslow.domain.product.controller;

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
@RequestMapping("products")
@RequiredArgsConstructor
public class ProductController {
	private final KnowhowService knowhowService;

	@PostMapping("/{productNo}/like")
	public Map<String, Long> likeProduct(Authentication authentication, @PathVariable("productNo") Long productNo
	) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return knowhowService.likeKnowhow(memberNo, productNo);
	}

	@DeleteMapping("/{productNo}/like")
	public Map<String, Long> unlikeProduct(Authentication authentication, @PathVariable("productNo") Long productNo
	) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return knowhowService.unlikeKnowhow(memberNo, productNo);
	}
}
