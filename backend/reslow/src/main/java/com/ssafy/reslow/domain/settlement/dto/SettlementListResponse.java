package com.ssafy.reslow.domain.settlement.dto;

import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import com.ssafy.reslow.domain.settlement.entity.Settlement;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class SettlementListResponse {
	private Long orderNo;
	private int amount;
	private LocalDateTime settlementDt;

	public static SettlementListResponse of(Settlement settlement) {
		return SettlementListResponse.builder()
			.amount(settlement.getAmount())
			.settlementDt(settlement.getCreatedDate())
			.orderNo(settlement.getOrder().getNo())
			.build();

	}
}
