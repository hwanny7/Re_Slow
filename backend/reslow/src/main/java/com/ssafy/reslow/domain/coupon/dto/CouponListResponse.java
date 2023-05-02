package com.ssafy.reslow.domain.coupon.dto;

import java.time.LocalDateTime;

import com.ssafy.reslow.domain.coupon.entity.Coupon;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CouponListResponse {

	Long couponNo;
	String name;
	String content;
	int discountType;
	int discountAmount;
	int discountPercent;
	LocalDateTime startDate;

	public static CouponListResponse of(Coupon coupon) {
		return CouponListResponse.builder()
			.couponNo(coupon.getNo())
			.name(coupon.getName())
			.content(coupon.getContent())
			.discountType(coupon.getDiscountType())
			.discountAmount(coupon.getDiscountAmount())
			.discountPercent(coupon.getDiscountPercent())
			.startDate(coupon.getStartDate())
			.build();
	}
}
