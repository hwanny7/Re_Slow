package com.ssafy.reslow.infra.delivery;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class DeliveryService {

	@Value("${delivery.api.key}")
	private String DELIVERY_API_KEY;
	private final WebClient webClient =
		WebClient
			.builder()
			.baseUrl("http://info.sweettracker.co.kr/")
			.build();
	public Map<String, Object> deliveryTracking(String t_code, String t_invoice) {

		Map<String, Object> response = webClient
			.get()
			.uri("api/v1/trackingInfo?t_code="+t_code+"&t_invoice="+t_invoice+"&t_invoice="+DELIVERY_API_KEY)
			.retrieve()
			.bodyToMono(Map.class)
			.block();

		return response;
	}
}
