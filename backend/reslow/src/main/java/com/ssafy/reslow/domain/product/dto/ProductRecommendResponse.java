package com.ssafy.reslow.domain.product.dto;

import com.ssafy.reslow.domain.product.entity.Product;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductRecommendResponse {

	private Long productNo;
	private String title;
	private int price;
	private String image;

	public static ProductRecommendResponse of(Product product) {
		return ProductRecommendResponse.builder()
			.productNo(product.getNo())
			.title(product.getTitle())
			.price(product.getPrice())
			.image(product.getProductImages() == null ? null : product.getProductImages().get(0).getUrl())
			.build();
	}
}
