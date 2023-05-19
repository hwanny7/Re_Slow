package com.ssafy.reslow.batch.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

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
@Table(name = "SETTLEMENT_TB")
@AttributeOverride(name = "no", column = @Column(name = "SETTLEMENT_PK"))
public class Settlement extends BaseEntity {

	@Column(name = "AMOUNT")
	private Long amount;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MEMBER_PK")
	private Member member;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ORDER_PK")
	private Order order;

	public static Settlement of(Order order) {
		return Settlement.builder()
			.amount(order.getTotalPrice())
			.member(order.getProduct().getMember())
			.order(order)
			.build();
	}
}
