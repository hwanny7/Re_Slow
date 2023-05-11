package com.ssafy.reslow.domain.order.dto;

import lombok.Getter;

@Getter
public class OrderUpdateCarrierRequest {

	private Long carrierTrack;
	private String carrierCompany;
}
