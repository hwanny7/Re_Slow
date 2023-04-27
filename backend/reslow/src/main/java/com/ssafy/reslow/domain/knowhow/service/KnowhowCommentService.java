package com.ssafy.reslow.domain.knowhow.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentCreateRequest;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentUpdateRequest;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowComment;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowCommentRepository;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowRepository;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.global.exception.ErrorCode;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class KnowhowCommentService {

	private final KnowhowCommentRepository commentRepository;
	private final MemberRepository memberRepository;
	private final KnowhowRepository knowhowRepository;

	public Slice<KnowhowCommentResponse> getCommentList(Long knowhowNo, Pageable pageable) {
		Slice<KnowhowComment> comments = commentRepository.findByKnowhowNoAndParentIsNull(knowhowNo, pageable);
		List<KnowhowCommentResponse> commentResponses = comments.getContent()
			.stream()
			.map(KnowhowCommentResponse::of)
			.collect(Collectors.toList());

		return new SliceImpl<>(commentResponses, pageable, comments.hasNext());
	}

	public Map<String, Object> createComment(Long memberNo, KnowhowCommentCreateRequest request) {
		Knowhow knowhow = knowhowRepository.findById(request.getKnowhowNo())
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		KnowhowComment parent =
			request.getParentNo() == null ? null : commentRepository.findById(request.getParentNo())
				.orElseThrow(() -> new CustomException(COMMENT_NOT_FOUND));

		KnowhowComment comment = KnowhowComment.of(knowhow, member, parent, request.getContent());
		Long savedCommentNo = commentRepository.save(comment).getNo();

		Map<String, Object> map = new HashMap<>();
		map.put("commentNo", savedCommentNo);
		return map;
	}

	public Map<String, Object> updateComment(Long memberNo, KnowhowCommentUpdateRequest request) {
		KnowhowComment comment = commentRepository.findById(request.getCommentNo())
			.orElseThrow(() -> new CustomException(ErrorCode.COMMENT_NOT_FOUND));

		if (!memberNo.equals(comment.getMember().getNo())) {
			throw new CustomException(ErrorCode.FORBIDDEN);
		}

		comment.updateContent(request.getContent());
		Long savedCommentNo = commentRepository.save(comment).getNo();

		Map<String, Object> map = new HashMap<>();
		map.put("commentNo", savedCommentNo);
		return map;
	}

	public void deleteComment(Long memberNo, Long commentNo) {
		KnowhowComment comment = commentRepository.findById(commentNo)
			.orElseThrow(() -> new CustomException(ErrorCode.COMMENT_NOT_FOUND));

		if (!memberNo.equals(comment.getMember().getNo())) {
			throw new CustomException(ErrorCode.FORBIDDEN);
		}

		commentRepository.deleteById(commentNo);
	}

}
