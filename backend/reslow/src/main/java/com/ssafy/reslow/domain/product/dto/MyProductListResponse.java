package com.ssafy.reslow.domain.product.dto;

import java.time.LocalDateTime;

import com.ssafy.reslow.domain.product.entity.Product;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MyProductListResponse {

	private Long productNo;
	private Long orderNo;
	private String title;
	private int price;
	private int status;
	private LocalDateTime date;
	private String image;

	public static MyProductListResponse of(Product product, String image, int status) {
		return MyProductListResponse.builder()
			.productNo(product.getNo())
			.orderNo(product.getOrder() == null ? null : product.getOrder().getNo())
			.title(product.getTitle())
			.price(product.getPrice())
			.status(status)
			.date(product.getCreatedDate())
			.image(image)
			.build();
	}
}
