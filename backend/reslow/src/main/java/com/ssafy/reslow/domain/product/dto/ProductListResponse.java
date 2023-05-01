package com.ssafy.reslow.domain.product.dto;

import java.time.LocalDate;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductListResponse {

	private String title;
	private int price;
	private Long productNo;
	private LocalDate date;
	private String image;

	public static ProductListResponse of(ProductListProjection product) {
		return ProductListResponse.builder()
			.productNo(product.getProductNo())
			.date(product.getDate())
			.price(product.getPrice())
			.title(product.getTitle())
			.image(product.getImage().isEmpty() ? null : product.getImage().get(0))
			.build();
	}
}
