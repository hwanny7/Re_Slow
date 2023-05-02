package com.ssafy.reslow.domain.coupon.repository;

import java.time.LocalDateTime;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.ssafy.reslow.domain.coupon.entity.IssuedCoupon;

public interface IssuedCouponRepository extends JpaRepository<IssuedCoupon, Long> {

	@Query("SELECT i FROM IssuedCoupon i INNER JOIN Coupon c WHERE i.member.no=:memberNo AND i.used=false AND c.startDate <= :now AND :now <= c.endDate")
	Slice<IssuedCoupon> findMyValidCoupon(Long memberNo, LocalDateTime now, Pageable pageable);
}