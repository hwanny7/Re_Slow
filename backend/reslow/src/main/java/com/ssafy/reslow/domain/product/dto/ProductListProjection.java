package com.ssafy.reslow.domain.product.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import com.querydsl.core.annotations.QueryProjection;

import lombok.Getter;

@Getter
public class ProductListProjection {

	private String title;
	private int price;
	private Long memberNo;
	private Long productNo;
	private LocalDate date;
	private List<String> image;

	@QueryProjection
	public ProductListProjection(Long memberNo, Long productNo, String title, int price, LocalDateTime date,
		List<String> image) {
		this.memberNo = memberNo;
		this.productNo = productNo;
		this.title = title;
		this.price = price;
		this.date = date.toLocalDate();
		this.image = image;
	}
}
