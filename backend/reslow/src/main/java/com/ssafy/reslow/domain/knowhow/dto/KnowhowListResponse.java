package com.ssafy.reslow.domain.knowhow.dto;

import lombok.Getter;

import java.util.List;

@Getter
public class KnowhowListResponse {
    List<KnowhowList> knowhowListList;

    public KnowhowListResponse(List<KnowhowList> list){
        this.knowhowListList = list;
    }

}
