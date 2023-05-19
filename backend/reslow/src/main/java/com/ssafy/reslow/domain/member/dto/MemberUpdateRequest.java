package com.ssafy.reslow.domain.member.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MemberUpdateRequest {

	private String recipient;
	private int zipcode;
	private String address;
	private String addressDetail;
	private String phoneNumber;
	private String memo;
}
