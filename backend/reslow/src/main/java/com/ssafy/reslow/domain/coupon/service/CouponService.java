package com.ssafy.reslow.domain.coupon.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssafy.reslow.domain.coupon.dto.CouponListResponse;
import com.ssafy.reslow.domain.coupon.entity.Coupon;
import com.ssafy.reslow.domain.coupon.repository.CouponRepository;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class CouponService {

	private final CouponRepository couponRepository;

	public Slice<CouponListResponse> getAllValidCoupons(Pageable pageable) {
		LocalDateTime now = LocalDateTime.now();
		Slice<Coupon> coupons = couponRepository.findByStartDateGreaterThanEqualAndEndDateLessThanEqual(now, now,
			pageable);
		List<CouponListResponse> couponListResponses = coupons.getContent()
			.stream()
			.map(CouponListResponse::of)
			.collect(Collectors.toList());
		return new SliceImpl<>(couponListResponses, pageable, coupons.hasNext());
	}
}
