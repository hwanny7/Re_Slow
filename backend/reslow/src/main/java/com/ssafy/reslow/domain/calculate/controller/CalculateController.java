package com.ssafy.reslow.domain.calculate.controller;

import java.time.LocalDateTime;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.calculate.service.CalculateService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("accounts")
@RequiredArgsConstructor
public class CalculateController {

	private final CalculateService calculateService;

	@GetMapping
	public String test() {
		return String.valueOf(LocalDateTime.now());
	}

}
