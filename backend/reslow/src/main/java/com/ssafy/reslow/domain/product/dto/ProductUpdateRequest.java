package com.ssafy.reslow.domain.product.dto;

import java.util.Set;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductUpdateRequest {

	private String title;
	private String description;
	private int deliveryFee;
	private int price;
	private Long category;
	private Set<Long> productImages;

	public static ProductUpdateRequest of(String title, String description, int deliveryFee, int price, Long category,
		Set<Long> productImages) {
		return ProductUpdateRequest.builder()
			.title(title)
			.description(description)
			.deliveryFee(deliveryFee)
			.price(price)
			.category(category)
			.productImages(productImages)
			.build();
	}
}
