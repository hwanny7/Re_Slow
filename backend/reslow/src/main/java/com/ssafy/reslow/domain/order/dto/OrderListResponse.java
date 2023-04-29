package com.ssafy.reslow.domain.order.dto;

import java.time.LocalDate;

import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
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
	private OrderStatus status;

	public static OrderListResponse of(Product product, Order order, String image) {
		return OrderListResponse.builder()
			.title(product.getTitle())
			.price(product.getPrice())
			.date(order.getCreatedDate().toLocalDate())
			.status(order.getStatus())
			.image(image)
			.build();
	}
}
