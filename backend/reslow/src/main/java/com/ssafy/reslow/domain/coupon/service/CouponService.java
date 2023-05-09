package com.ssafy.reslow.domain.coupon.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.coupon.dto.CouponCreateRequest;
import com.ssafy.reslow.domain.coupon.dto.CouponDetailResponse;
import com.ssafy.reslow.domain.coupon.dto.CouponListResponse;
import com.ssafy.reslow.domain.coupon.dto.IssuedCouponListResponse;
import com.ssafy.reslow.domain.coupon.entity.Coupon;
import com.ssafy.reslow.domain.coupon.entity.IssuedCoupon;
import com.ssafy.reslow.domain.coupon.repository.CouponRepository;
import com.ssafy.reslow.domain.coupon.repository.IssuedCouponRepository;
import com.ssafy.reslow.domain.manager.entity.Manager;
import com.ssafy.reslow.domain.manager.repository.ManagerRepository;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.infra.storage.StorageClient;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class CouponService {

	private final CouponRepository couponRepository;
	private final IssuedCouponRepository issuedCouponRepository;
	private final MemberRepository memberRepository;
	private final ManagerRepository managerRepository;
	private final StorageClient storageClient;

	public Slice<CouponListResponse> getAllValidCoupons(Pageable pageable) {
		LocalDateTime now = LocalDateTime.now();
		Slice<Coupon> coupons = couponRepository.findByStartDateLessThanEqualAndEndDateGreaterThanEqual(now, now,
			pageable);
		List<CouponListResponse> couponListResponses = coupons.getContent()
			.stream()
			.map(CouponListResponse::of)
			.collect(Collectors.toList());
		return new SliceImpl<>(couponListResponses, pageable, coupons.hasNext());
	}

	public CouponDetailResponse getCouponDetail(Long couponNo) {
		Coupon coupon = couponRepository.findById(couponNo).orElseThrow(() -> new CustomException(COUPON_NOT_FOUND));
		return CouponDetailResponse.of(coupon);
	}

	public Slice<IssuedCouponListResponse> getMyValidCoupons(Long memberNo, Pageable pageable) {
		Slice<IssuedCoupon> coupons = issuedCouponRepository.findMyValidCoupon(memberNo, LocalDateTime.now(), pageable);
		List<IssuedCouponListResponse> couponListResponses = coupons.getContent()
			.stream()
			.map(IssuedCouponListResponse::of)
			.collect(Collectors.toList());
		return new SliceImpl<>(couponListResponses, pageable, coupons.hasNext());
	}

	public Map<String, Long> createCoupon(Long managerNo, CouponCreateRequest couponCreateRequest,
		MultipartFile image) throws IOException {
		Manager manager = managerRepository.getReferenceById(managerNo);
		String imageUrl = storageClient.uploadFile(image);
		Coupon coupon = Coupon.of(manager, couponCreateRequest, imageUrl);
		coupon = couponRepository.save(coupon);

		Map<String, Long> map = new HashMap<>();
		map.put("couponNo", coupon.getNo());
		return map;
	}

	public Map<String, Long> deleteCoupon(Long managerNo, Long couponNo) {
		Coupon coupon = couponRepository.findById(couponNo)
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		if (!managerNo.equals(coupon.getManager().getNo())) {
			throw new CustomException(USER_NOT_MATCH);
		}
		couponRepository.delete(coupon);

		Map<String, Long> map = new HashMap<>();
		map.put("couponNo", couponNo);
		return map;
	}

	public Map<String, Long> issueCoupon(Long memberNo, Long couponNo) {
		Long count = issuedCouponRepository.countByMemberNoAndCouponNo(memberNo, couponNo);
		if (count > 0)
			throw new CustomException(COUPON_ALREADY_ISSUED);

		Member member = memberRepository.getReferenceById(memberNo);
		Coupon coupon = couponRepository.findById(couponNo).orElseThrow(() -> new CustomException(COUPON_NOT_FOUND));
		IssuedCoupon issuedCoupon = IssuedCoupon.of(member, coupon);
		issuedCoupon = issuedCouponRepository.save(issuedCoupon);

		Map<String, Long> map = new HashMap<>();
		map.put("issuedCouponNo", issuedCoupon.getNo());
		return map;
	}

	public Map<String, Long> useIssuedCoupon(Long memberNo, Long issuedCouponNo) {
		IssuedCoupon issuedCoupon = issuedCouponRepository.findById(issuedCouponNo)
			.orElseThrow(() -> new CustomException(COUPON_NOT_FOUND));
		if (!memberNo.equals(issuedCoupon.getMember().getNo())) {
			throw new CustomException(USER_NOT_MATCH);
		}
		issuedCoupon.use();
		issuedCouponRepository.save(issuedCoupon);

		Map<String, Long> map = new HashMap<>();
		map.put("issuedCouponNo", issuedCoupon.getNo());
		return map;
	}
}
