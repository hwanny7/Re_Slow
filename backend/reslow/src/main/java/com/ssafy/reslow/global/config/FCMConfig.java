package com.ssafy.reslow.global.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import com.google.firebase.messaging.FirebaseMessaging;

@Configuration
public class FCMConfig {
	// @Bean
	FirebaseMessaging firebaseMessaging() throws Exception {
		ClassPathResource resource = new ClassPathResource("firebase/firebase_service_key.json");

	}
}
