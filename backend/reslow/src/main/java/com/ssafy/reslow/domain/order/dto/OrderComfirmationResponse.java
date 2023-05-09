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
	private LocalDateTime date;
	private String recipient;
	private int zipcode;
	private String address;
	private String addressDetail;
	private String phoneNumber;
	private String memo;
	private int totalPrice;
	private int productPrice;
	private int discountPrice;
	private int deliveryFee;

	public static OrderComfirmationResponse of(Product product, Order order) {
		int totalPrice = product.getPrice() + product.getDeliveryFee();
		double discount = 0;
		if (order.getIssuedCoupon() != null) {
			discount = order.getIssuedCoupon().getCoupon().getDiscountPercent() * 0.01;
			totalPrice -= (int)(totalPrice * discount);
		}
		return OrderComfirmationResponse.builder()
			.title(product.getTitle())
			.totalPrice(totalPrice)
			.productPrice(product.getPrice())
			.discountPrice((int)discount)
			.deliveryFee(product.getDeliveryFee())
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
