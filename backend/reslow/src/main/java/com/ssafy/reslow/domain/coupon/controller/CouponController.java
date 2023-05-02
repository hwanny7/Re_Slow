package com.ssafy.reslow.domain.coupon.controller;

import java.util.Map;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.coupon.dto.CouponCreateRequest;
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

	@PostMapping
	public Map<String, Long> createCoupon(Authentication authentication, CouponCreateRequest couponCreateRequest) {
		Long managerNo = Long.parseLong(authentication.getName());
		return couponService.createCoupon(managerNo, couponCreateRequest);
	}

	@DeleteMapping("/{couponNo}")
	public Map<String, Long> deleteCoupon(Authentication authentication, @PathVariable Long couponNo) {
		Long managerNo = Long.parseLong(authentication.getName());
		return couponService.deleteCoupon(managerNo, couponNo);
	}

}
