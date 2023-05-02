package com.ssafy.reslow.domain.product.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.ssafy.reslow.domain.product.entity.Product;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductDetailResponse {

	private boolean mine;
	private String title;
	private String description;
	private int deliveryFee;
	private int price;
	private String category;
	private LocalDateTime date;
	private List<String> images;

	public static ProductDetailResponse of(Product product, String category, boolean mine, List<String> images) {
		return ProductDetailResponse.builder()
			.title(product.getTitle())
			.description(product.getDescription())
			.deliveryFee(product.getDeliveryFee())
			.price(product.getPrice())
			.category(category)
			.mine(mine)
			.date(product.getCreatedDate())
			.images(images)
			.build();
	}
}
