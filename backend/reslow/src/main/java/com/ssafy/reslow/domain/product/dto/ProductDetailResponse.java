package com.ssafy.reslow.domain.product.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.ssafy.reslow.domain.product.entity.Product;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProductDetailResponse {

	private String nickname;
	private String profileImg;
	private boolean mine;
	private String title;
	private String description;
	private int deliveryFee;
	private int price;
	private String category;
	private LocalDateTime date;
	private List<String> images;
	private boolean myHeart;
	private Long heartCount;

	public static ProductDetailResponse of(Product product, String category, boolean mine, boolean myHeart,
		Long heartCount, List<String> images) {
		return ProductDetailResponse.builder()
			.nickname(product.getMember().getNickname())
			.profileImg(product.getMember().getProfilePic())
			.title(product.getTitle())
			.description(product.getDescription())
			.deliveryFee(product.getDeliveryFee())
			.price(product.getPrice())
			.category(category)
			.mine(mine)
			.myHeart(myHeart)
			.heartCount(heartCount)
			.date(product.getCreatedDate())
			.images(images)
			.build();
	}
}
