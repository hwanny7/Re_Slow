package com.ssafy.reslow.domain.market.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

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
@Table(name = "PRODUCT_TB")
@AttributeOverride(name = "no", column = @Column(name = "PRODUCT_PK"))
public class Product extends BaseEntity {

	@Column(name = "NAME")
	private String name;

	@Column(name = "PRICE")
	private Long price;

	@Column(name = "STOCK")
	private Long stock;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRODUCT_INTRO_PK")
	private ProductIntro productIntro;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ORDER_PK")
	private Order order;
}
