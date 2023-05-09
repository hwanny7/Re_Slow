package com.ssafy.reslow.domain.order.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.response.Payment;
import com.ssafy.reslow.global.exception.CustomException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PaymentService {
	@Value("${iamport.api.key}")
	private String apiKey;

	@Value("${iamport.api.secret}")
	private String apiSecret;

	public Payment getPayment(String impUid) {
		log.info("impUid : "+impUid);
		IamportClient client = new IamportClient(apiKey, apiSecret);
		try {
			return client.paymentByImpUid(impUid).getResponse();
		} catch (IamportResponseException e) {
			throw new CustomException(PAYMENT_FAILED);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
}