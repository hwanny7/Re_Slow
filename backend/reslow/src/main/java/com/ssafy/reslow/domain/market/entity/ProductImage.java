package com.ssafy.reslow.domain.market.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "PRODUCT_IMAGE_TB")
public class ProductImage {
	@Id
	@GeneratedValue
	@Column(name = "PRODUCT_IMAGE_PK")
	private Long no;

	@Column(name = "IMAGE_URL")
	private String url;
}
