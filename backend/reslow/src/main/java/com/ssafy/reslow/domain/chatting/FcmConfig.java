package com.ssafy.reslow.domain.chatting;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FcmConfig {
	private static final String FCM_API_URL = "https://fcm.googleapis.com/fcm/send";
	@Value("${fcm.credentials.fcm-server-key}")
	private static String FCM_SERVER_KEY;

	// @Bean
	// public RestTemplate restTemplate() {
	// 	RestTemplate restTemplate = new RestTemplate();
	// 	restTemplate.setInterceptors(List.of(new ClientHttpRequestInterceptor() {
	// 		@Override
	// 		public ClientHttpResponse intercept(HttpRequest request, byte[] body,
	// 			ClientHttpRequestExecution execution) throws IOException {
	// 			request.getHeaders().add(HttpHeaders.AUTHORIZATION, "key=" + FCM_SERVER_KEY);
	// 			request.getHeaders().add(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
	// 			return execution.execute(request, body);
	// 		}
	// 	}));
	// 	return restTemplate;
	// }
}
