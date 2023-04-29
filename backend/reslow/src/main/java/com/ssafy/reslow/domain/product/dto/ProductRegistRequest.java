package com.ssafy.reslow.domain.product.dto;

import lombok.Getter;

@Getter
public class ProductRegistRequest {

	private String title;
	private String description;
	private int deliveryFee;
	private int price;
	private Long category;
}
