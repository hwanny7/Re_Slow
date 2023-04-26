package com.ssafy.reslow.global.exception;

import org.springframework.http.HttpStatus;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ErrorCode {
	ACCESS_TOKEN_EXPIRED(HttpStatus.UNAUTHORIZED, -1,"만료된 Access Token 입니다."),
	BAD_REQUEST(HttpStatus.BAD_REQUEST, -2, "잘못된 요청입니다."),
	METHOD_NOT_ALLOWED(HttpStatus.METHOD_NOT_ALLOWED, -3, "허용되지 않은 메서드입니다."),
	INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, -4, "내부 서버 오류입니다."),
	FORBIDDEN(HttpStatus.FORBIDDEN, -5, "권한이 없는 사용자입니다."),
	ENTITY_NOT_FOUND(HttpStatus.OK, -6, "엔티티를 찾을 수 없습니다.");

	private final HttpStatus status;
	private final int code;
	private final String message;
}