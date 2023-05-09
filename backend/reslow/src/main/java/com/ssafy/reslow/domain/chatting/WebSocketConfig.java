package com.ssafy.reslow.domain.chatting;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
@CrossOrigin(origins = "*")
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

	@Override
	public void configureMessageBroker(MessageBrokerRegistry config) {
		config.enableSimpleBroker("/sub"); // 메시지를 구독하는 요청의 prefix는 /sub로 시작
		config.setApplicationDestinationPrefixes("/pub"); // 메시지 발행을 요청하는 요청의 prefix는 /pub로 시작
	}

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) { // endpoint 등록
		registry.addEndpoint("/ws")
			.setAllowedOriginPatterns("*")
			.withSockJS(); // sock.js를 통하여 낮은 버전의 브라우저에서도 websocket이 동작할 수 있게함
	}

}
