package com.ssafy.reslow.domain.knowhow.dto;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class KnowhowRequest {
	Long categoryNo;
	String title;
	List<String> contentList;
	List<MultipartFile> imageList;

	public static KnowhowRequest of(Long categoryNo, String title, List<String> contentList,
		List<MultipartFile> imageList) {
		return KnowhowRequest.builder()
			.categoryNo(categoryNo)
			.title(title)
			.contentList(contentList)
			.imageList(imageList)
			.build();
	}
}
