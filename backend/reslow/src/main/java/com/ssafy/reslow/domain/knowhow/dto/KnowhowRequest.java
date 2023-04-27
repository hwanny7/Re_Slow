package com.ssafy.reslow.domain.knowhow.dto;

import lombok.Getter;

import java.util.List;

@Getter
public class KnowhowRequest {
    Long categoryNo;
    String title;
    List<String> contentList;
}
