package com.ssafy.reslow.domain.product.dto;

import java.util.Set;

import lombok.Getter;

@Getter
public class ProductUpdateRequest {

	private String title;
	private String description;
	private int deliveryFee;
	private int price;
	private int stock;
	private Long category;
	private Set<Long> productImages;
}
