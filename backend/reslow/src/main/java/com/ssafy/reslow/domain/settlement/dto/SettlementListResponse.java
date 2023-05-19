package com.ssafy.reslow.domain.settlement.dto;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssafy.reslow.domain.settlement.entity.Settlement;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class SettlementListResponse {
	private Long orderNo;
	private int amount;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private LocalDateTime settlementDt;

	public static SettlementListResponse of(Settlement settlement) {
		return SettlementListResponse.builder()
			.amount(settlement.getAmount())
			.settlementDt(settlement.getCreatedDate())
			.orderNo(settlement.getOrder().getNo())
			.build();

	}
}
