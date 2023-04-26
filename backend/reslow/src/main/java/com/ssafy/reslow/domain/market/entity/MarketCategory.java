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
@Table(name = "MARKET_CATEGORY_TB")
public class MarketCategory {

	@Id
	@GeneratedValue
	@Column(name = "MARKET_CATEGORY_PK")
	private Long no;

	@Column(name = "MARKET_CATEGORY")
	private String category;

}
