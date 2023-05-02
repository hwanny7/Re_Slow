package com.ssafy.reslow.domain.member.dto;

import com.ssafy.reslow.domain.member.entity.MemberAddress;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MemberAddressResponse {
	private String recipient;
	private int zipcode;
	private String address;
	private String addressDetail;
	private String phoneNumber;
	private String memo;

	public static MemberAddressResponse of(MemberAddress memberAddress) {
		return MemberAddressResponse.builder()
			.recipient(memberAddress.getRecipient())
			.zipcode(memberAddress.getZipCode())
			.address(memberAddress.getAddress())
			.addressDetail(memberAddress.getAddressDetail())
			.phoneNumber(memberAddress.getPhoneNum())
			.memo(memberAddress.getMemo())
			.build();
	}
}
