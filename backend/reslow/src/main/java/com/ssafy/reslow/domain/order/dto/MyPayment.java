package com.ssafy.reslow.domain.order.dto;

import lombok.Getter;

@Getter
public class MyPayment {
	private String merchantUid;
	private String name;
	private int amount;
	private String buyerName;
	private String buyerEmail;
	private String buyerTel;
}