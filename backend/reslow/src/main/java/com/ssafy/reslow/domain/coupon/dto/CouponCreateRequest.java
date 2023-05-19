package com.ssafy.reslow.domain.coupon.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CouponCreateRequest {
	private String name;
	private String content;
	private int discountType;
	private int discountAmount;
	private int discountPercent;
	private int minimumOrderAmount;
	private LocalDateTime startDate;
	private LocalDateTime endDate;
	private int totalQuantity;
}
