package com.ssafy.reslow.domain.settlement.dto;

import java.time.LocalDateTime;

import com.ssafy.reslow.domain.settlement.entity.Settlement;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class SettlementListResponse {

	private int amount;
	private LocalDateTime settlementDt;
	private Long orderNo;

	public static SettlementListResponse of(Settlement settlement) {
		return SettlementListResponse.builder()
			.amount(settlement.getAmount())
			.settlementDt(settlement.getCreatedDate())
			.orderNo(settlement.getOrder().getNo())
			.build();

	}
}
