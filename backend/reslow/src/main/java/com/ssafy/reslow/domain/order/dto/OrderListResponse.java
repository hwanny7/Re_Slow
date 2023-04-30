package com.ssafy.reslow.domain.order.dto;

import java.time.LocalDate;

import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.product.entity.Product;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class OrderListResponse {

	private String title;
	private int price;
	private LocalDate date;
	private String image;
	private int status;

	public static OrderListResponse of(Product product, Order order, String image, int status) {
		return OrderListResponse.builder()
			.title(product.getTitle())
			.price(product.getPrice())
			.date(order.getCreatedDate().toLocalDate())
			.status(status)
			.image(image)
			.build();
	}
}
