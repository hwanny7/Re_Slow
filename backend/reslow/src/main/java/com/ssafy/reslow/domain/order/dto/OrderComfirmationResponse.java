package com.ssafy.reslow.domain.order.dto;

import java.time.LocalDateTime;

import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.product.entity.Product;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class OrderComfirmationResponse {

	private String title;
	private int price;
	private LocalDateTime date;
	private String recipient;
	private int zipcode;
	private String address;
	private String addressDetail;
	private String phoneNumber;
	private String memo;

	public static OrderComfirmationResponse of(Product product, Order order) {
		return OrderComfirmationResponse.builder()
			.title(product.getTitle())
			.price(product.getPrice())
			.date(order.getCreatedDate())
			.recipient(order.getRecipient())
			.zipcode(order.getZipcode())
			.address(order.getAddress())
			.addressDetail(order.getAddressDetail())
			.phoneNumber(order.getPhoneNumber())
			.memo(order.getMemo())
			.build();
	}
}
