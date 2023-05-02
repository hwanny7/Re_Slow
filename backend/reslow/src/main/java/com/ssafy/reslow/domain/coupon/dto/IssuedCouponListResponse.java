package com.ssafy.reslow.domain.coupon.dto;

import com.ssafy.reslow.domain.coupon.entity.IssuedCoupon;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class IssuedCouponListResponse {
	private Long issuedCouponNo;
	private CouponDetailResponse coupon;

	public static IssuedCouponListResponse of(IssuedCoupon issuedCoupon) {
		return IssuedCouponListResponse.builder()
			.issuedCouponNo(issuedCoupon.getNo())
			.coupon(CouponDetailResponse.of(issuedCoupon.getCoupon()))
			.build();
	}
}
