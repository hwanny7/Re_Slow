package com.ssafy.reslow.domain.coupon.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.ssafy.reslow.domain.member.entity.Member;
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
@Table(name = "ISSUED_COUPON_TB")
@AttributeOverride(name = "no", column = @Column(name = "ISSUED_COUPON_PK"))
public class IssuedCoupon extends BaseEntity {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MEMBER_PK")
	private Member member;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "COUPON_PK")
	private Coupon coupon;

	@Column(name = "USED")
	private boolean used;

	public static IssuedCoupon of(Member member, Coupon coupon) {
		return IssuedCoupon.builder()
			.member(member)
			.coupon(coupon)
			.used(false)
			.build();
	}
}
