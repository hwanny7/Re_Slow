package com.ssafy.reslow.domain.order.dto;

import lombok.Getter;

@Getter
public class OrderRegistRequest {

	private Long productNo;
	private String recipient;
	private int zipcode;
	private String address;
	private String addressDetail;
	private String phoneNumber;
	private String memo;
}
