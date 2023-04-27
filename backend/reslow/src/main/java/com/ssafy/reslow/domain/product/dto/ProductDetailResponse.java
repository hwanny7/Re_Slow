package com.ssafy.reslow.domain.product.dto;

import java.util.List;

import com.ssafy.reslow.domain.product.entity.Product;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductDetailResponse {

	private String title;
	private String description;
	private int deliveryFee;
	private int price;
	private int stock;
	private String category;
	private List<String> images;

	public static ProductDetailResponse of(Product product, String category, List<String> images) {
		return ProductDetailResponse.builder()
			.title(product.getTitle())
			.description(product.getDescription())
			.deliveryFee(product.getDeliveryFee())
			.price(product.getPrice())
			.stock(product.getStock())
			.category(category)
			.images(images)
			.build();
	}
}
