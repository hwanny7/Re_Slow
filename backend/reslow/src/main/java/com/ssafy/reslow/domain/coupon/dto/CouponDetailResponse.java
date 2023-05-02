package com.ssafy.reslow.domain.coupon.dto;

import java.time.LocalDateTime;

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
	private LocalDateTime startDate;
	private LocalDateTime endDate;

}
