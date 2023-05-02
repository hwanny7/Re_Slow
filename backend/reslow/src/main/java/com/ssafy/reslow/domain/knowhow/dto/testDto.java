package com.ssafy.reslow.domain.knowhow.dto;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;

@Getter
public class testDto {
	Long boardNo;
	Long categoryNo;
	String title;
	List<String> contentList;
	List<MultipartFile> imageList;
}
