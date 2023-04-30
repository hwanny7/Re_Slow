package com.ssafy.reslow.domain.order.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.product.entity.OrderStatusConverter;
import com.ssafy.reslow.domain.product.entity.Product;
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
@Table(name = "ORDER_TB")
@AttributeOverride(name = "no", column = @Column(name = "ORDER_PK"))
public class Order extends BaseEntity {

	@Column(name = "STATUS")
	@Convert(converter = OrderStatusConverter.class)
	private OrderStatus status;

	@Column(name = "RECIPIENT")
	private String recipient;

	@Column(name = "ZIPCODE")
	private int zipcode;

	@Column(name = "ADDRESS")
	private String address;

	@Column(name = "ADDRESS_DETAIL")
	private String addressDetail;

	@Column(name = "PHONE_NUM")
	private String phoneNumber;

	@Column(name = "MEMO")
	private String memo;

	@Column(name = "CARRIER_COMPANY")
	private String company;

	@Column(name = "CARRIER_TRACK")
	private int carrierTrack;

	@OneToOne(mappedBy = "order")
	private Product product;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MEMBER_PK")
	private Member buyer;
}
