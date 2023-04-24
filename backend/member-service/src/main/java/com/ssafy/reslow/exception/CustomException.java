package com.ssafy.reslow.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class CustomException extends RuntimeException {
	private final ErrorCode errorCode;
}
