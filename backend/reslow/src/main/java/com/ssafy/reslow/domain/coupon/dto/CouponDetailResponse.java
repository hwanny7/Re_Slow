package com.ssafy.reslow.domain.coupon.dto;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CouponDetailResponse {

	Long couponNo;
	String name;
	String content;
	int discountType;
	int discountAmount;
	int discountPercent;
	int minimumOrderAmount;
	LocalDateTime startDate;
	LocalDateTime endDate;

}
