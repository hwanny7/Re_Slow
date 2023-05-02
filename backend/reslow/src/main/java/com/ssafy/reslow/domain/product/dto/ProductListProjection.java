package com.ssafy.reslow.domain.product.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.querydsl.core.annotations.QueryProjection;

import lombok.Getter;

@Getter
public class ProductListProjection {

	private final String title;
	private final int price;
	private final Long memberNo;
	private final Long productNo;
	private final LocalDateTime datetime;
	private final List<String> image;

	@QueryProjection
	public ProductListProjection(Long memberNo, Long productNo, String title, int price, LocalDateTime datetime,
		List<String> image) {
		this.memberNo = memberNo;
		this.productNo = productNo;
		this.title = title;
		this.price = price;
		this.datetime = datetime;
		this.image = image;
	}
}
