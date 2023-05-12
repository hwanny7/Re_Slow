package com.ssafy.reslow.domain.chatting;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Configuration
@EnableWebSocketMessageBroker
@CrossOrigin(origins = "*")
@Slf4j
@RequiredArgsConstructor
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

	@Override
	public void configureMessageBroker(MessageBrokerRegistry config) {
		config.enableSimpleBroker("/sub"); // sub로 시작하는 topic을 가진 메시지를 받으면 해당 주제를 구독하는 클라이언트들에게 메시지 발송
		config.setApplicationDestinationPrefixes("/pub"); // 메시지 발행을 요청하는 요청의 prefix는 /pub로 시작
	}

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) { // endpoint 등록
		registry.addEndpoint("/ws")
			.setAllowedOriginPatterns("*")
			.withSockJS(); // sock.js를 통하여 낮은 버전의 브라우저에서도 websocket이 동작할 수 있게함
	}

	@EventListener
	public void handleWebSocketConnectListener(SessionConnectedEvent event) {
		System.out.println("소켓 연결됨!!!!!!!!!!!!!!");
		log.info("Received a new web socket connection");
	}

	@EventListener
	public void handelWebSocketDisConnectListener(SessionDisconnectEvent event) {
		System.out.println("소켓 끊어짐 ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ");
	}
}
