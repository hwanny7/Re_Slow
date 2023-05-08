package com.ssafy.reslow.domain.chatting;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpRequest;
import org.springframework.http.MediaType;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.web.client.RestTemplate;

@Configuration
public class FcmConfig {
	private static final String FCM_API_URL = "https://fcm.googleapis.com/fcm/send";
	@Value("${fcm.credentials.fcm-server-key}")
	private static String FCM_SERVER_KEY;

	@Bean
	public RestTemplate restTemplate() {
		RestTemplate restTemplate = new RestTemplate();
		restTemplate.setInterceptors(List.of(new ClientHttpRequestInterceptor() {
			@Override
			public ClientHttpResponse intercept(HttpRequest request, byte[] body,
				ClientHttpRequestExecution execution) throws IOException {
				request.getHeaders().add(HttpHeaders.AUTHORIZATION, "key=" + FCM_SERVER_KEY);
				request.getHeaders().add(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
				return execution.execute(request, body);
			}
		}));
		return restTemplate;
	}
}
