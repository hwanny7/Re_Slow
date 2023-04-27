package com.ssafy.reslow.domain.knowhow.controller;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentResponse;
import com.ssafy.reslow.domain.knowhow.service.KnowhowCommentService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RestController
@RequestMapping("knowhows/comments")
public class KnowhowCommentController {

    private final KnowhowCommentService commentService;

    @GetMapping
    public Slice<KnowhowCommentResponse> getCommentList(
        @RequestParam("knowhowNo") Long knowhowNo,
        Pageable pageable
    ){
        return commentService.getCommentList(knowhowNo, pageable);
    }
}
