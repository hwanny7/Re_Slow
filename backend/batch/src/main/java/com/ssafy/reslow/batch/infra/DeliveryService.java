package com.ssafy.reslow.batch.infra;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;

@Component
@Slf4j
public class DeliveryService {

    @Value("${delivery.api.key}")
    private String DELIVERY_API_KEY;

    public String deliveryTracking(String t_code, String t_invoice) {
        WebClient webClient = WebClient.builder()
            .exchangeStrategies(ExchangeStrategies.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(16 * 1024 * 1024))
                .build())
            .baseUrl("http://info.sweettracker.co.kr/tracking/5")
            .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
            .build();

        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("t_key", DELIVERY_API_KEY);
        formData.add("t_code", t_code);
        formData.add("t_invoice", t_invoice);

        String response = webClient.post()
            .body(BodyInserters.fromFormData(formData))
            .retrieve()
            .bodyToMono(String.class)
            .block();

        return response;
    }

    public String directDeliveryTracking(String t_code, String t_invoice) {
        WebClient webClient = WebClient.builder()
            .exchangeStrategies(ExchangeStrategies.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(16 * 1024 * 1024))
                .build())
            .baseUrl("http://info.sweettracker.co.kr/api/v1/trackingInfo?t_code=" + t_code
                + "&t_invoice=" + t_invoice + "&t_key=" + DELIVERY_API_KEY)
            .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
            .build();

        String response = webClient.get()
            .retrieve()
            .bodyToMono(String.class)
            .block();
        return response;
    }
}
