package com.ssafy.reslow.domain.coupon.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.ssafy.reslow.domain.coupon.dto.CouponCreateRequest;
import com.ssafy.reslow.domain.manager.entity.Manager;
import com.ssafy.reslow.global.common.entity.BaseEntity;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "COUPON_TB")
@AttributeOverride(name = "no", column = @Column(name = "COUPON_PK"))
public class Coupon extends BaseEntity {

	@Column(name = "NAME")
	private String name;

	@Column(name = "CONTENT")
	private String content;

	@Column(name = "DISCOUNT_TYPE")
	private int discountType;

	@Column(name = "DISCOUNT_AMOUNT")
	private int discountAmount;

	@Column(name = "DISCOUNT_PERCENT")
	private int discountPercent;

	@Column(name = "MINIMUM_ORDER_AMOUNT")
	private int minimumOrderAmount;

	@Column(name = "START_DT")
	private LocalDateTime startDate;

	@Column(name = "END_DT")
	private LocalDateTime endDate;

	@Column(name = "TOTAL_QUANTITY")
	private int totalQuantity;

	@Column(name = "REMAINING_QUANTITY")
	private int remainQuantity;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MANAGER_PK")
	private Manager manager;

	@Builder.Default
	@OneToMany(mappedBy = "member", cascade = CascadeType.ALL)
	private List<IssuedCoupon> issuedCoupons = new ArrayList<>();

	public static Coupon of(Manager manager, CouponCreateRequest couponCreateRequest) {
		return Coupon.builder()
			.name(couponCreateRequest.getName())
			.content(couponCreateRequest.getContent())
			.discountType(couponCreateRequest.getDiscountType())
			.discountAmount(couponCreateRequest.getDiscountAmount())
			.discountPercent(couponCreateRequest.getDiscountPercent())
			.minimumOrderAmount(couponCreateRequest.getMinimumOrderAmount())
			.startDate(couponCreateRequest.getStartDate())
			.endDate(couponCreateRequest.getEndDate())
			.totalQuantity(couponCreateRequest.getTotalQuantity())
			.remainQuantity(couponCreateRequest.getTotalQuantity())
			.manager(manager)
			.build();
	}
}
