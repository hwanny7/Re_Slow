package com.ssafy.reslow.domain.calculate.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.order.entity.Order;
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
@Table(name = "CALCULATE_TB")
@AttributeOverride(name = "no", column = @Column(name = "CALCULATE_PK"))
public class Calculate extends BaseEntity {
	@Column(name = "AMOUNT")
	private int amount;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MEMBER_PK")
	private Member member;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ORDER_PK")
	private Order order;

}
