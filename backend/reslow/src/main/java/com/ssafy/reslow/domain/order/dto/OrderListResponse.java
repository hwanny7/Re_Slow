package com.ssafy.reslow.domain.order.dto;

import java.time.LocalDateTime;

import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.product.entity.Product;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class OrderListResponse {

	private Long orderNo;
	private String title;
	private int price;
	private LocalDateTime date;
	private String image;
	private int status;

	public static OrderListResponse of(Product product, Order order, String image, int status) {
		return OrderListResponse.builder()
			.title(product.getTitle())
			.orderNo(order.getNo())
			.price(product.getPrice())
			.date(order.getCreatedDate())
			.status(status)
			.image(image)
			.build();
	}
}
