package com.ssafy.reslow.domain.product.dto;

import com.ssafy.reslow.domain.product.entity.Product;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductUpdateResponse {

	private String title;
	private String description;
	private int deliveryFee;
	private int price;
	private int stock;
	private String category;

	public static ProductUpdateResponse of(Product product, String category) {
		return ProductUpdateResponse.builder()
			.title(product.getTitle())
			.description(product.getDescription())
			.deliveryFee(product.getDeliveryFee())
			.price(product.getPrice())
			.stock(product.getStock())
			.category(category)
			.build();
	}
}
