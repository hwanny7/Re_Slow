package com.ssafy.reslow.domain.member.dto;

import lombok.Getter;

@Getter
public class MemberUpdateRequest {

	private String nickname;
	private String recipient;
	private int zipCode;
	private String address;
	private String addressDetail;
	private String phoneNum;
	private String memo;
}
