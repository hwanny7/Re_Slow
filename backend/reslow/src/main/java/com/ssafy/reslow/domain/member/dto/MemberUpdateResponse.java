package com.ssafy.reslow.domain.member.dto;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.entity.MemberAddress;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MemberUpdateResponse {

	private String nickname;
	private String profilePic;
	private String recipient;
	private int zipCode;
	private String address;
	private String addressDetail;
	private String phoneNum;
	private String memo;

	public static MemberUpdateResponse of(Member member, MemberAddress memberAddress) {
		return MemberUpdateResponse.builder()
			.nickname(member.getNickname())
			.profilePic(member.getProfilePic())
			.recipient(memberAddress.getRecipient())
			.zipCode(memberAddress.getZipCode())
			.address(memberAddress.getAddress())
			.addressDetail(memberAddress.getAddressDetail())
			.phoneNum(memberAddress.getPhoneNum())
			.memo(memberAddress.getMemo())
			.build();
	}
}
