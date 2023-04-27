package com.ssafy.reslow.domain.knowhow.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentResponse;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowComment;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowCommentRepository;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class KnowhowCommentService {

    private final KnowhowCommentRepository commentRepository;

    public Slice<KnowhowCommentResponse> getCommentList(Long knowhowNo, Pageable pageable) {
        Slice<KnowhowComment> comments = commentRepository.findByKnowhowNoAndParentIsNull(knowhowNo, pageable);
        List<KnowhowCommentResponse> commentResponses = comments.getContent()
            .stream()
            .map(comment -> {
                List<KnowhowCommentResponse> children = comment.getChildren()
                    .stream()
                    .map(child -> KnowhowCommentResponse.builder()
                        .commentNo(child.getNo())
                        .memberNo(child.getMember().getNo())
                        .parentNo(child.getParent() != null ? child.getParent().getNo() : null)
                        .profilePic(child.getMember().getProfilePic())
                        .nickname(child.getMember().getNickname())
                        .datetime(child.getCreatedDate())
                        .content(child.getContent())
                        .build())
                    .collect(Collectors.toList());

                return KnowhowCommentResponse.builder()
                    .commentNo(comment.getNo())
                    .memberNo(comment.getMember().getNo())
                    .parentNo(comment.getParent() != null ? comment.getParent().getNo() : null)
                    .profilePic(comment.getMember().getProfilePic())
                    .nickname(comment.getMember().getNickname())
                    .datetime(comment.getCreatedDate())
                    .content(comment.getContent())
                    .children(children != null && !children.isEmpty() ? children : null)
                    .build();
            })
            .collect(Collectors.toList());

        return new SliceImpl<>(commentResponses, pageable, comments.hasNext());
    }

}
