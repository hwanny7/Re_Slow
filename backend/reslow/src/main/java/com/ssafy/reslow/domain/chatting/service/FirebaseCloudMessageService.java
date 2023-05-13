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
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.global.exception.ErrorCode;

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
	private final MemberRepository memberRepository;

	public void sendMessageTo(FcmMessage.SendMessage sendMessage, Long memberNo) throws
		IOException,
		FirebaseMessagingException {
		String message = makeMessage(sendMessage, memberNo);

		System.out.println("보내는 메시지 : " + message);

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

		System.out.println("결과 : " + response);
	}

	public String makeMessage(FcmMessage.SendMessage sendMessage, Long memberNo) throws
		JsonProcessingException,
		FirebaseMessagingException {
		Member sender = memberRepository.findById(memberNo)
			.orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

		FcmMessage fcmMessage = FcmMessage.builder()
			.message(FcmMessage.Message.builder()
				.token(sendMessage.getTargetToken())
				.notification(FcmMessage.Notification.builder()
					.title(sendMessage.getTitle())
					.body(sendMessage.getBody())
					.build()
				)
				.data(FcmMessage.Data.builder()
					.roomId(sendMessage.getRoomId())
					.type(sendMessage.getType())
					.senderNickname(sender.getNickname())
					.senderProfilePic(sender.getProfilePic())
					.build())
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
