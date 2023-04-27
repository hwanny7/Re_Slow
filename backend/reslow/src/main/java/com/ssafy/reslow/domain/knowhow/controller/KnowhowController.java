package com.ssafy.reslow.domain.knowhow.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowRequest;
import com.ssafy.reslow.domain.knowhow.service.KnowhowService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/knowhows")
public class KnowhowController {

	private final KnowhowService knowhowService;

	@PostMapping("/")
	public ResponseEntity<Map<String, Object>> writeKnowhowPosting(
		@RequestPart("imageList") List<MultipartFile> multipartFileList,
		@RequestPart("knowhowRequest") KnowhowRequest request, Authentication authentication) throws IOException {
		Long memberNo = Long.parseLong(authentication.getName());

		HashMap<String, Object> responseMap = new HashMap<>();
		responseMap.put("msg", knowhowService.saveKnowhow(memberNo, multipartFileList, request));

		return ResponseEntity.ok(responseMap);
	}

}
