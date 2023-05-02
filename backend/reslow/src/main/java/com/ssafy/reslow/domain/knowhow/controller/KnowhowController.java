package com.ssafy.reslow.domain.knowhow.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
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
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowDetailResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowListResponse;
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

	// @PostMapping("/")
	// public Map<String, Object> writeKnowhowPosting(
	// 	@RequestPart("imageList") List<MultipartFile> multipartFileList,
	// 	@RequestPart("knowhowRequest") KnowhowRequest request, Authentication authentication) throws IOException {
	// 	Long memberNo = Long.parseLong(authentication.getName());
	//
	// 	HashMap<String, Object> responseMap = new HashMap<>();
	// 	responseMap.put("msg", knowhowService.saveKnowhow(memberNo, multipartFileList, request));
	//
	// 	return responseMap;
	// }

	@PostMapping("/")
	public Map<String, Object> writeKnowhowPosting(
		@RequestPart List<MultipartFile> imageList, @RequestBody List<String> contentList, @RequestBody String title,
		@RequestBody Long categoryNo,
		Authentication authentication) throws
		IOException {
		Long memberNo = Long.parseLong(authentication.getName());

		HashMap<String, Object> responseMap = new HashMap<>();
		responseMap.put("msg", knowhowService.saveKnowhow(memberNo, imageList, KnowhowRequest.builder()
			.contentList(contentList)
			.title(title)
			.categoryNo(categoryNo)
			.build()));

		return responseMap;
	}

	@PostMapping("/test")
	public String test(@RequestPart List<MultipartFile> files, @RequestParam("knowhowNo") Long knowhowNo) {
		log.error("이 글의 번호는 : " + knowhowNo);
		log.error("라라라랄라라라라라 여기기기여기 밑에 보자1!!!!!!!!!!!!!");
		for (MultipartFile file : files)
			log.error(file.getOriginalFilename());

		return "받았나?";
	}

	@GetMapping("/detail/{knowhowNo}")
	public KnowhowDetailResponse getKnowhowDetail(@PathVariable("knowhowNo") Long knowhowNo) {

		return knowhowService.getKnowhowDetail(knowhowNo);
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
	public List<KnowhowListResponse> getKnowhowPostingList(Pageable pageable, @RequestParam("category") Long category,
		@RequestParam("keyword") String keyword) {
		return knowhowService.getKnowhowList(pageable, category, keyword);
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
}
