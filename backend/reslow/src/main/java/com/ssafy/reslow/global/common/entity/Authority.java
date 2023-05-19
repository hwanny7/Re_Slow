package com.ssafy.reslow.global.common.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum Authority {

	USER("일반 사용자"),
	MANAGER("관리자");

	private final String description;
}
