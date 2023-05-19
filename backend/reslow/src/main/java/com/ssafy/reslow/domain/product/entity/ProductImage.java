package com.ssafy.reslow.domain.product.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@SuperBuilder
@Table(name = "PRODUCT_IMAGE_TB")
public class ProductImage {
	@Id
	@GeneratedValue
	@Column(name = "PRODUCT_IMAGE_PK")
	private Long no;

	@Column(name = "IMAGE_URL")
	private String url;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRODUCT_PK")
	private Product product;

	public static ProductImage of(Product product, String imageSrc) {
		return ProductImage.builder()
			.url(imageSrc)
			.product(product)
			.build();
	}
}
