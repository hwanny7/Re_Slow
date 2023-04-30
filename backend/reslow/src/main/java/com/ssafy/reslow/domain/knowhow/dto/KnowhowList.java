package com.ssafy.reslow.domain.knowhow.dto;

import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class KnowhowList {
    String writer;
    String profile;
    String title;
    List<String> pictureList;
    Long likeCnt;
    Long commentCnt;


    public static KnowhowList ofEntity(Knowhow knowhow, List<String> pictureList, Long likeCnt, Long commentCnt){
        return KnowhowList.builder()
                .writer(knowhow.getMember().getNickname())
                .profile(knowhow.getMember().getProfilePic())
                .title(knowhow.getTitle())
                .pictureList(pictureList)
                .likeCnt(likeCnt)
                .commentCnt(commentCnt)
                .build();
    }
}
