package com.ssafy.reslow.domain.knowhow.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowDetailResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowRequest;
import com.ssafy.reslow.domain.knowhow.service.KnowhowService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("knowhows")
@RequiredArgsConstructor
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

	@GetMapping("/detail/{knowhowNo}")
	public ResponseEntity<KnowhowDetailResponse> getKnowhowDetail(@PathVariable("knowhowNo") Long knowhowNo) {

		return ResponseEntity.ok(knowhowService.getKnowhowDetail(knowhowNo));
	}

	/*
	@PutMapping("/")
	public ResponseEntity<Map<String, Object>> updateKnowhowPosting(
		@RequestPart("imageList") List<MultipartFile> multipartFileList,
		@RequestPart("knowhowRequest") KnowhowUpdateRequest request, Authentication authentication) throws IOException {
		Long memberNo = Long.parseLong(authentication.getName());

		HashMap<String, Object> responseMap = new HashMap<>();

		return ResponseEntity.ok(responseMap);
	}
	*/

	@PostMapping("/{knowhowNo}/like")
	public Map<String, Long> likeKnowhow(Authentication authentication, @PathVariable("knowhowNo") Long knowhowNo
	) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return knowhowService.likeKnowhow(memberNo, knowhowNo);
	}

	@DeleteMapping("/{knowhowNo}/like")
	public Map<String, Long> unlikeKnowhow(Authentication authentication, @PathVariable("knowhowNo") Long knowhowNo
	) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return knowhowService.unlikeKnowhow(memberNo, knowhowNo);
	}
}
