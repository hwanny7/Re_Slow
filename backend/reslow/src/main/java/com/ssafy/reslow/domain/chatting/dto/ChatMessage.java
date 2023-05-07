package com.ssafy.reslow.domain.chatting.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class ChatMessage {
    private String sender;
    private String receiver;
    private String message;
}
