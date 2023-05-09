package com.ssafy.reslow.domain.account.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.account.service.AccountService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("accounts")
@RequiredArgsConstructor
public class AccountController {

	private final AccountService accountService;

}
