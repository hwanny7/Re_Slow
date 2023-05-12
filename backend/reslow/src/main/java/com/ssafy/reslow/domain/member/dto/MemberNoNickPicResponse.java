package com.ssafy.reslow.domain.member.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MemberNoNickPicResponse {
	Long memberNo;
	String nickname;
	String profilePic;

	public static MemberNoNickPicResponse of(Long memberNo, String nickname, String profilePic) {
		return MemberNoNickPicResponse.builder()
			.memberNo(memberNo)
			.nickname(nickname)
			.profilePic(profilePic)
			.build();
	}
}
