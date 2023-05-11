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

	public void sendMessageTo(String targetToken, String title, String body) throws
		IOException,
		FirebaseMessagingException {
		String message = makeMessage(targetToken, title, body);

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

		System.out.println(response.body().string());
	}

	public String makeMessage(String targetToken, String title, String body) throws
		JsonProcessingException,
		FirebaseMessagingException {
		// List<String> tokenList = new ArrayList<>();
		// tokenList.add(targetToken);
		// MulticastMessage multicastMessage = MulticastMessage.builder()
		// 	.setNotification(Notification.builder()
		// 		.setTitle("멀티캐스트 테스트~~~!! 타이틀이얏")
		// 		.setBody("이거는 바디^^")
		// 		.build())
		// 	.addAllTokens(tokenList)
		// 	.build();
		//
		// BatchResponse response = FirebaseMessaging.getInstance().sendMulticast(multicastMessage);
		// if (response.getFailureCount() > 0) {
		// 	List<SendResponse> responses = response.getResponses();
		// 	List<String> failedTokens = new ArrayList<>();
		// 	for (int i = 0; i < responses.size(); i++) {
		// 		if (!responses.get(i).isSuccessful()) {
		// 			failedTokens.add(tokenList.get(i));
		// 		}
		// 	}
		//
		// 	System.out.println("List of tokens that caused failures: "
		// 		+ failedTokens);
		// }
		FcmMessage fcmMessage = FcmMessage.builder()
			.message(FcmMessage.Message.builder()
				// .registration_ids(list)
				.token(targetToken)
				// .registration_tokens(list)
				.notification(FcmMessage.Notification.builder()
					.title(title)
					.body(body)
					.image(null)
					.build()
				)
				.build()
			)
			.validate_only(false)
			.build();

		return objectMapper.writeValueAsString(fcmMessage);
		// return objectMapper.writeValueAsString(response);
	}

	private String getAccessToken() throws IOException {
		String firebaseConfigPath = "firebase/firebase-service-key2.json";
		GoogleCredentials googleCredentials = GoogleCredentials
			.fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())
			.createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));
		googleCredentials.refreshIfExpired();
		return googleCredentials.getAccessToken().getTokenValue();
	}
}
