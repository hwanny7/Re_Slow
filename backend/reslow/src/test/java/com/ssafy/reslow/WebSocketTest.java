package com.ssafy.reslow;

import static org.assertj.core.api.AssertionsForClassTypes.*;

import java.util.Collections;
import java.util.concurrent.TimeUnit;

import org.junit.Test;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.messaging.converter.MappingJackson2MessageConverter;
import org.springframework.messaging.simp.stomp.StompSession;
import org.springframework.messaging.simp.stomp.StompSessionHandlerAdapter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.reactive.socket.client.StandardWebSocketClient;
import org.springframework.web.socket.WebSocketHttpHeaders;
import org.springframework.web.socket.client.WebSocketClient;
import org.springframework.web.socket.messaging.WebSocketStompClient;
import org.springframework.web.socket.sockjs.client.SockJsClient;
import org.springframework.web.socket.sockjs.client.WebSocketTransport;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
public class WebSocketTest {

	@Autowired
	private WebApplicationContext webApplicationContext;
	@Autowired
	private MockMvc mockMvc;

	private WebSocketStompClient stompClient;
	private StompSession stompSession;

	@BeforeEach
	public void setUp() throws Exception {
		stompClient = new WebSocketStompClient(new SockJsClient(
			Collections.singletonList(new WebSocketTransport((WebSocketClient)new StandardWebSocketClient()))));
		stompClient.setMessageConverter(new MappingJackson2MessageConverter());
		stompSession = stompClient
			.connect("ws://192.168.0.26/ws", new WebSocketHttpHeaders(), new StompSessionHandlerAdapter() {
			})
			.get(1, TimeUnit.SECONDS);
	}

	@AfterEach
	public void tearDown() {
		if (stompSession != null) {
			stompSession.disconnect();
		}
	}

	@Test
	public void testConnection() throws Exception {
		assertThat(stompSession.isConnected()).isTrue();
	}

}
