package com.ssafy.reslow.domain.notice.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.notice.dto.NoticeResponse;
import com.ssafy.reslow.domain.notice.dto.NoticeStatusRequest;
import com.ssafy.reslow.domain.notice.service.NoticeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@RequestMapping("/notices")
@RestController
public class NoticeController {

	private final NoticeService noticeService;

	@PatchMapping
	public Map<String, Boolean> updateNoticeStatus(Authentication authentication,
		@RequestBody NoticeStatusRequest request) {
		Long memberNo = Long.parseLong(authentication.getName());
		noticeService.updateNoticeStatus(memberNo, request);

		Map<String, Boolean> response = new HashMap<>();
		response.put("alert", request.isAlert());
		return response;
	}

	@GetMapping
	public List<NoticeResponse> getNoticeList(Authentication authentication, Pageable pageable) {
		Long memberNo = Long.parseLong(authentication.getName());
		return noticeService.getNoticeList(memberNo, pageable);
	}

	@DeleteMapping("/{noticeNo}")
	public Map<String, Long> deleteNotice(Authentication authentication, @PathVariable Long noticeNo) {
		Long memberNo = Long.parseLong(authentication.getName());
		noticeService.deleteNotice(memberNo, noticeNo);

		Map<String, Long> response = new HashMap<>();
		response.put("delete", noticeNo);
		return response;
	}
}
