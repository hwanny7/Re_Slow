package com.ssafy.reslow.domain.knowhow.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowCommentResponse {
    private Long commentNo;
    private Long memberNo;
    private Long parentNo;
    private String profilePic;
    private String nickname;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "Asia/Seoul")
    private LocalDateTime datetime;
    private String content;
    private List<KnowhowCommentResponse> children;

}
