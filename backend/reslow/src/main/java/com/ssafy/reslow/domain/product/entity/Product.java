package com.ssafy.reslow.domain.product.entity;

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
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.product.dto.ProductRegistRequest;
import com.ssafy.reslow.domain.product.dto.ProductUpdateRequest;
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
	@Column(name = "TITLE")
	private String title;

	@Column(name = "DESCRIPTION", columnDefinition = "TEXT")
	private String description;

	@Column(name = "DELIVERY_FEE")
	private int deliveryFee;

	@Column(name = "PRICE")
	private int price;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MEMBER_PK")
	private Member member;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRODUCT_CATEGORY_PK")
	private ProductCategory productCategory;

	@Builder.Default
	@OneToMany(mappedBy = "product", cascade = CascadeType.ALL)
	private List<ProductImage> productImages = new ArrayList<>();

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ORDER_PK")
	private Order order;

	public static Product of(Member member, ProductRegistRequest request, ProductCategory productCategory) {
		return Product.builder()
			.member(member)
			.title(request.getTitle())
			.description(request.getDescription())
			.deliveryFee(request.getDeliveryFee())
			.price(request.getPrice())
			.productCategory(productCategory)
			.build();
	}

	public void setProductImages(List<ProductImage> productImages) {
		this.productImages = productImages;
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	public void updateProduct(ProductUpdateRequest request, ProductCategory productCategory) {
		this.title = request.getTitle();
		this.description = request.getDescription();
		this.productCategory = productCategory;
		this.deliveryFee = request.getDeliveryFee();
		this.price = request.getPrice();
	}
}
