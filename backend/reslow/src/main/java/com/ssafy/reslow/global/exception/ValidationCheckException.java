package com.ssafy.reslow.global.exception;

import org.springframework.validation.Errors;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ValidationCheckException extends RuntimeException {
	private final ErrorCode errors;
}
