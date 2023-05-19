package com.ssafy.reslow.global.common.dto;

import com.ssafy.reslow.domain.member.entity.Member;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Builder
@Getter
@Setter
@AllArgsConstructor
public class TokenResponse {

    private String grantType;
    private String accessToken;
    private String refreshToken;
    private Long refreshTokenExpirationTime;
    private boolean existAccount;
    private String nickname;
    private String profileImg;

    public void setInfo(boolean existAccount, Member member) {
        this.existAccount = existAccount;
        this.nickname = member.getNickname();
        this.profileImg = member.getProfilePic();
    }
}
