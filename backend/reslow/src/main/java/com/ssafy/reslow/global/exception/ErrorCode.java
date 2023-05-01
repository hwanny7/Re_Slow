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
	ENTITY_NOT_FOUND(HttpStatus.NOT_FOUND, -6, "엔티티를 찾을 수 없습니다."),
	MEBER_ALREADY_EXSIST(HttpStatus.UNAUTHORIZED, -7, "이미 회원가입된 아이디입니다."),
	MEMBER_NOT_FOUND(HttpStatus.UNAUTHORIZED, -8, "사용자를 찾을 수 없습니다."),
	PASSWORD_NOT_MATCH(HttpStatus.UNAUTHORIZED, -9, "비밀번호가 일치하지 않습니다."),
	KNOWHOW_NOT_FOUND(HttpStatus.NOT_FOUND, -10, "노하우를 찾을 수 없습니다."),
	COMMENT_NOT_FOUND(HttpStatus.NOT_FOUND, -11, "댓글을 찾을 수 없습니다."),
	CATEGORY_NOT_FOUND(HttpStatus.NOT_FOUND, -12, "카테고리를 찾을 수 없습니다."),
	PRODUCT_NOT_FOUND(HttpStatus.NOT_FOUND, -13, "상품을 찾을 수 없습니다."),
	ORDER_NOT_FOUND(HttpStatus.NOT_FOUND, -14, "상품을 찾을 수 없습니다."),
	USER_NOT_MATCH(HttpStatus.UNAUTHORIZED, -15, "사용자 접근 권한이 없습니다."),
	VALIDATION_CHECK(HttpStatus.UNAUTHORIZED, -16, "유효성 검사를 다시 실시해주세요.");

	private final HttpStatus status;
	private final int code;
	private final String message;
}
