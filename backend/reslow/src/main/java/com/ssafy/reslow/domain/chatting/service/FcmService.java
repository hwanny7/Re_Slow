package com.ssafy.reslow.domain.chatting.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class FcmService {
    @Autowired
    private RestTemplate restTemplate;
    private static final String FCM_API_URL = "https://fcm.googleapis.com/fcm/send";

    public void sendNotification(String receiver, String message) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("to", "/topics/" + receiver);
        Map<String, Object> notification = new HashMap<>();
        notification.put("title", "New Message");
        notification.put("body", message);
        requestBody.put("notification", notification);
        restTemplate.postForObject(FCM_API_URL, requestBody, Object.class);
    }
}
