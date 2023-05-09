package com.ssafy.reslow.domain.order.service;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.response.Payment;

@Service
public class PaymentService {
	@Value("${iamport.api.key}")
	private String apiKey;

	@Value("${iamport.api.secret}")
	private String apiSecret;

	public Payment getPayment(String impUid) throws IamportResponseException, IOException {
		IamportClient client = new IamportClient(apiKey, apiSecret);
		return client.paymentByImpUid(impUid).getResponse();
	}
}