package com.ssafy.reslow.domain.chatting.service;

import java.io.IOException;
import java.util.List;

import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.ssafy.reslow.domain.chatting.dto.FcmMessage;

import lombok.RequiredArgsConstructor;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

@Component
@RequiredArgsConstructor
public class FirebaseCloudMessageService {
	private final String API_URL = "https://fcm.googleapis.com/v1/projects/reslow-ce26b/messages:send";
	private final ObjectMapper objectMapper;

	public void sendMessageTo(FcmMessage.SendMessage sendMessage) throws
		IOException,
		FirebaseMessagingException {
		String message = makeMessage(sendMessage);

		OkHttpClient client = new OkHttpClient();
		RequestBody requestBody = RequestBody.create(message, MediaType.get("application/json; charset=utf-8"));
		Request request = new Request.Builder()
			.url(API_URL)
			.post(requestBody)
			.addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + getAccessToken())
			.addHeader(HttpHeaders.CONTENT_TYPE, "application/json; UTF-8")
			.build();

		Response response = client.newCall(request)
			.execute();

	}

	public String makeMessage(FcmMessage.SendMessage sendMessage) throws
		JsonProcessingException,
		FirebaseMessagingException {
		FcmMessage fcmMessage = FcmMessage.builder()
			.message(FcmMessage.Message.builder()
				.token(sendMessage.getTargetToken())
				.notification(FcmMessage.Notification.builder()
					.title(sendMessage.getTitle())
					.body(sendMessage.getBody())
					.build()
				)
				.data(FcmMessage.Data.builder().roomId(sendMessage.getRoomId()).type(sendMessage.getType()).build())
				.build()
			)
			.validate_only(false)
			.build();

		return objectMapper.writeValueAsString(fcmMessage);
	}

	private String getAccessToken() throws IOException {
		String firebaseConfigPath = "firebase/firebase-service-key.json";
		GoogleCredentials googleCredentials = GoogleCredentials
			.fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())
			.createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));
		googleCredentials.refreshIfExpired();
		return googleCredentials.getAccessToken().getTokenValue();
	}
}
