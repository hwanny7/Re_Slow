package com.ssafy.reslow.domain.product.dto;

import java.time.LocalDateTime;
import java.util.List;

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
	private String category;
	private LocalDateTime date;
	private List<String> images;

	public static ProductUpdateResponse of(Product product, String category, List<String> images) {
		return ProductUpdateResponse.builder()
			.title(product.getTitle())
			.description(product.getDescription())
			.deliveryFee(product.getDeliveryFee())
			.price(product.getPrice())
			.category(category)
			.date(product.getCreatedDate())
			.images(images)
			.build();
	}
}
