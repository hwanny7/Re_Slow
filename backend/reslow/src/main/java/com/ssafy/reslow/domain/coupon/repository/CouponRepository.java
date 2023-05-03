package com.ssafy.reslow.domain.coupon.repository;

import java.time.LocalDateTime;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.reslow.domain.coupon.entity.Coupon;

public interface CouponRepository extends JpaRepository<Coupon, Long> {
	Slice<Coupon> findByStartDateLessThanEqualAndEndDateGreaterThanEqual(LocalDateTime now, LocalDateTime now1,
		Pageable pageable);
}