package com.ssafy.reslow.domain.product.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductRegistRequest {

	private String title;
	private String description;
	private int deliveryFee;
	private int price;
	private Long category;

	public static ProductRegistRequest of(String title, String description, int deliveryFee, int price, Long category) {
		return ProductRegistRequest.builder()
			.title(title)
			.description(description)
			.deliveryFee(deliveryFee)
			.price(price)
			.category(category)
			.build();
	}
}
