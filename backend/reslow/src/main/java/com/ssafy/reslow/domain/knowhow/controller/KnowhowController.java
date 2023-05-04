package com.ssafy.reslow.domain.knowhow.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.PageRequest;
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
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowDetailResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowListResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowRecommendRequest;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowRecommendResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowRequest;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowUpdateRequest;
import com.ssafy.reslow.domain.knowhow.service.KnowhowService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("knowhows")
@RequiredArgsConstructor
@Slf4j
public class KnowhowController {
	private final KnowhowService knowhowService;

	@PostMapping("/")
	public Map<String, Object> writeKnowhowPosting(
		@RequestPart List<MultipartFile> imageList, @RequestParam List<String> contentList, @RequestParam String title,
		@RequestParam Long categoryNo,
		Authentication authentication) throws
		IOException {
		Long memberNo = Long.parseLong(authentication.getName());

		HashMap<String, Object> responseMap = new HashMap<>();
		responseMap.put("msg",
			knowhowService.saveKnowhow(memberNo, KnowhowRequest.of(categoryNo, title, contentList, imageList)));

		return responseMap;
	}

	@GetMapping("/detail/{knowhowNo}")
	public KnowhowDetailResponse getKnowhowDetail(Authentication authentication,
		@PathVariable("knowhowNo") Long knowhowNo) {
		Long memberNo = Long.parseLong(authentication.getName());
		return knowhowService.getKnowhowDetail(memberNo, knowhowNo);
	}

	@PutMapping("/")
	public Map<String, Object> updateKnowhowPosting(
		@RequestPart("imageList") List<MultipartFile> multipartFileList,
		@RequestPart("knowhowUpdateRequest") KnowhowUpdateRequest updateRequest, Authentication authentication) throws
		IOException {
		Long memberNo = Long.parseLong(authentication.getName());

		HashMap<String, Object> responseMap = new HashMap<>();
		responseMap.put("msg", knowhowService.updateKnowhow(memberNo, multipartFileList, updateRequest));

		return responseMap;
	}

	@DeleteMapping("/{knowhowNo}")
	public Map<String, Object> deleteKnowhowPosting(Authentication authentication,
		@PathVariable("knowhowNo") Long knowhowNo) {
		Long memberNo = Long.parseLong(authentication.getName());

		HashMap<String, Object> responseMap = new HashMap<>();
		responseMap.put("msg", knowhowService.deleteKnowhow(memberNo, knowhowNo));
		return responseMap;
	}

	@GetMapping("")
	public List<KnowhowListResponse> getKnowhowPostingList(
		Authentication authentication,
		Pageable pageable,
		@RequestParam(required = false) Long category,
		@RequestParam(required = false) String keyword) {
		Long memberNo = Long.parseLong(authentication.getName());
		return knowhowService.getKnowhowList(memberNo, pageable, category, KnowhowRecommendRequest.of(keyword));
	}

	@GetMapping("/mylist")
	public List<KnowhowListResponse> getKMynowhowPostingList(Authentication authentication, Pageable pageable) {
		Long memberNo = Long.parseLong(authentication.getName());
		return knowhowService.getMyKnowhowList(pageable, memberNo);
	}

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

	@GetMapping("/likes")
	public Slice<KnowhowListResponse> likeProductList(Authentication authentication, Pageable pageable) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return knowhowService.likeKnowhowList(memberNo, pageable);
	}

	/**
	 * 키워드별 추천
	 * @param authentication
	 * @param keywords
	 * @return List<KnowhowListResponse>
	 */
	@PostMapping("/recommends")
	public List<KnowhowListResponse> recommendKnowhowPosting(Authentication authentication,
		@RequestBody KnowhowRecommendRequest keywords) {
		Long memberNo = Long.parseLong(authentication.getName());
		return knowhowService.getRecommendKnowhowList(memberNo, PageRequest.of(0, 100), keywords);
	}

	@GetMapping("/recommends/main")
	public List<KnowhowRecommendResponse> recommendMainKnowhow() {
		return knowhowService.getMainKnowhowList();
	}
}
