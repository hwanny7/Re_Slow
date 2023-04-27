package com.ssafy.reslow.domain.product.dto;

import com.ssafy.reslow.domain.member.entity.Member;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductUpdateResponse {

	private String nickname;

	public static ProductUpdateResponse of(Member member) {
		return ProductUpdateResponse.builder()
			.build();
	}
}
