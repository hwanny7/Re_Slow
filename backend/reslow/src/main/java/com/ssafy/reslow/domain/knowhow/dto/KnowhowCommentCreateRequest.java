package com.ssafy.reslow.domain.knowhow.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class KnowhowCommentCreateRequest {
    private Long knowhowNo;
    private Long parentNo;
    private String content;
}

