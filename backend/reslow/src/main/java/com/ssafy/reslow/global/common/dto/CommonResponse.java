package com.ssafy.reslow.global.common.dto;

import org.springframework.http.HttpStatus;

import com.ssafy.reslow.global.exception.ErrorCode;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

public class CommonResponse {

    @Builder
    @Getter
    @AllArgsConstructor
    public static class TokenInfo {

        private String grantType;
        private String accessToken;
        private String refreshToken;
        private Long refreshTokenExpirationTime;
    }

    @Builder
    @Getter
    @AllArgsConstructor
    public static class Reissue {

        private int state;
        private String message;
        private String error;

        public static Reissue reissue() {
            return Reissue.builder()
                .state(HttpStatus.UNAUTHORIZED.value())
                .message(ErrorCode.ACCESS_TOKEN_EXPIRED.getMessage())
                .error("TOKEN-0001")
                .build();
        }
    }
}
