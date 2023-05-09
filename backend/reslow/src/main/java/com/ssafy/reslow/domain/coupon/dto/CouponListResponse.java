package com.ssafy.reslow.domain.coupon.dto;

import java.time.LocalDateTime;

import com.ssafy.reslow.domain.coupon.entity.Coupon;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CouponListResponse {

	private Long couponNo;
	private String name;
	private String content;
	private int discountType;
	private int discountAmount;
	private int discountPercent;
	private LocalDateTime startDate;
	private LocalDateTime endDate;
	private String imageUrl;

	public static CouponListResponse of(Coupon coupon) {
		return CouponListResponse.builder()
			.couponNo(coupon.getNo())
			.name(coupon.getName())
			.content(coupon.getContent())
			.discountType(coupon.getDiscountType())
			.discountAmount(coupon.getDiscountAmount())
			.discountPercent(coupon.getDiscountPercent())
			.startDate(coupon.getStartDate())
			.endDate(coupon.getEndDate())
			.imageUrl(coupon.getImageUrl())
			.build();
	}
}
