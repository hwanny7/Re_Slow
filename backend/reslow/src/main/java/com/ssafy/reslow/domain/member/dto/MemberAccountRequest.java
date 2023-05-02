package com.ssafy.reslow.domain.member.dto;

import lombok.Getter;

@Getter
public class MemberAccountRequest {

	private String accountHolder;
	private String accountNumber;
	private String bank;
}
