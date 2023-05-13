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

	public static MemberUpdateRequest of(String recipient, int zipCode, String address,
		String addressDetail,
		String phoneNum, String memo) {
		return MemberUpdateRequest.builder()
			.recipient(recipient)
			.zipcode(zipCode)
			.address(address)
			.addressDetail(addressDetail)
			.phoneNumber(phoneNum)
			.memo(memo)
			.build();
	}
}
