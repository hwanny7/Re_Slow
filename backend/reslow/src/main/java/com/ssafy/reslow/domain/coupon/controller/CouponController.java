package com.ssafy.reslow.domain.coupon.controller;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.coupon.dto.CouponListResponse;
import com.ssafy.reslow.domain.coupon.service.CouponService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("coupons")
@RequiredArgsConstructor
public class CouponController {

	private final CouponService couponService;

	@GetMapping("/all")
	public Slice<CouponListResponse> getAllValidCoupons(Pageable pageable) {
		return couponService.getAllValidCoupons(pageable);
	}

}
