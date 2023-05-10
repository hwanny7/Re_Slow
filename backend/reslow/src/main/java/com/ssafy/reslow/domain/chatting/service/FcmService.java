package com.ssafy.reslow.domain.chatting.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.global.exception.CustomException;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FcmService {
	private final RestTemplate restTemplate;
	private final MemberRepository memberRepository;
	private static final String FCM_API_URL = "https://fcm.googleapis.com/fcm/send";

	public void sendNotification(List<String> receiver, Long senderNo, String message) {
		Member sender = memberRepository.findById(senderNo)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		Map<String, Object> requestBody = new HashMap<>();
		requestBody.put("registration_ids", receiver); // 다중 수신
		Map<String, Object> notification = new HashMap<>();
		notification.put("title", sender.getNickname()); // 제목은 보낸 사람 닉네임
		notification.put("body", message);
		requestBody.put("notification", notification);
		restTemplate.postForObject(FCM_API_URL, requestBody, Object.class);
	}
}
