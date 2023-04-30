package com.ssafy.reslow.domain.knowhow.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class KnowhowCommentUpdateRequest {
    private Long commentNo;
    private String content;
}
