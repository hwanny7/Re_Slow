package com.ssafy.reslow.domain.coupon.dto;

import java.time.LocalDateTime;

import com.ssafy.reslow.domain.coupon.entity.Coupon;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CouponDetailResponse {

	private Long couponNo;
	private String name;
	private String content;
	private int discountType;
	private int discountAmount;
	private int discountPercent;
	private int minimumOrderAmount;
	private int totalQuantity;
	private LocalDateTime startDate;
	private LocalDateTime endDate;

	public static CouponDetailResponse of(Coupon coupon) {
		return CouponDetailResponse.builder()
			.couponNo(coupon.getNo())
			.name(coupon.getName())
			.content(coupon.getContent())
			.discountType(coupon.getDiscountType())
			.discountAmount(coupon.getDiscountAmount())
			.discountPercent(coupon.getDiscountPercent())
			.minimumOrderAmount(coupon.getMinimumOrderAmount())
			.startDate(coupon.getStartDate())
			.endDate(coupon.getEndDate())
			.totalQuantity(coupon.getTotalQuantity())
			.build();
	}

}
