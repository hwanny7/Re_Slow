package com.ssafy.reslow.domain.market.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.global.common.BaseEntity;

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
@Table(name = "PRODUCT_INTRO_TB")
@AttributeOverride(name = "no", column = @Column(name = "PRODUCT_INTRO_PK"))
public class ProductIntro extends BaseEntity {
	@Column(name = "TITLE")
	private String title;

	@Column(name = "DESCRIPTION", columnDefinition = "TEXT")
	private String description;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MEMBER_PK")
	private Member member;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MARKET_CATEGORY_PK")
	private MarketCategory marketCategory;

	@Builder.Default
	@OneToMany(mappedBy = "productIntro")
	private List<ProductImage> productImages = new ArrayList<>();

	@Builder.Default
	@OneToMany(mappedBy = "productIntro")
	private List<Product> products = new ArrayList<>();
}
