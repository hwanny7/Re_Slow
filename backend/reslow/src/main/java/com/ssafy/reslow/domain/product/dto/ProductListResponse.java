package com.ssafy.reslow.domain.product.dto;

import java.time.LocalDateTime;

import com.ssafy.reslow.domain.product.entity.Product;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductListResponse {

	private String title;
	private int price;
	private Long productNo;
	private LocalDateTime datetime;
	private String image;
	private boolean myHeart;
	private Long likeCount;

	public static ProductListResponse of(ProductListProjection product, boolean myHeart, Long likeCount) {
		return ProductListResponse.builder()
			.productNo(product.getProductNo())
			.datetime(product.getDatetime())
			.price(product.getPrice())
			.title(product.getTitle())
			.myHeart(myHeart)
			.likeCount(likeCount)
			.image(product.getImage().isEmpty() ? null : product.getImage().get(0))
			.build();
	}

	public static ProductListResponse of(Product product, Long likeCount) {
		return ProductListResponse.builder()
			.productNo(product.getNo())
			.datetime(product.getCreatedDate())
			.price(product.getPrice())
			.title(product.getTitle())
			.likeCount(likeCount)
			.image(product.getProductImages().isEmpty() ? null : product.getProductImages().get(0).getUrl())
			.build();
	}
}
