package com.ssafy.reslow.domain.chatting.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class FcmService {
	@Autowired
	private RestTemplate restTemplate;
	private static final String FCM_API_URL = "https://fcm.googleapis.com/fcm/send";

	public void sendNotification(List<String> receiver, String message) {
		Map<String, Object> requestBody = new HashMap<>();
		requestBody.put("registration_ids", receiver); // 다중 수신
		Map<String, Object> notification = new HashMap<>();
		notification.put("title", "New Message");
		notification.put("body", message);
		requestBody.put("notification", notification);
		restTemplate.postForObject(FCM_API_URL, requestBody, Object.class);
	}
}
