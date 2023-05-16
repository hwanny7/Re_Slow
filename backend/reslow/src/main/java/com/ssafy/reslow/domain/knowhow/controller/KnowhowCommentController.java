package com.ssafy.reslow.domain.knowhow.controller;

import java.io.IOException;
import java.util.Map;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentCreateRequest;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentUpdateRequest;
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
	) {
		return commentService.getCommentList(knowhowNo, pageable);
	}

	@PostMapping
	public Map<String, Object> createComment(
		Authentication authentication,
		@RequestBody KnowhowCommentCreateRequest request
	) throws IOException, FirebaseMessagingException {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return commentService.createComment(memberNo, request);
	}

	@PutMapping
	public Map<String, Object> updateComment(
		Authentication authentication,
		@RequestBody KnowhowCommentUpdateRequest request
	) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return commentService.updateComment(memberNo, request);
	}

	@DeleteMapping("/{commentNo}")
	public void deleteComment(
		Authentication authentication,
		@PathVariable("commentNo") Long commentNo
	) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		commentService.deleteComment(memberNo, commentNo);
	}
}
