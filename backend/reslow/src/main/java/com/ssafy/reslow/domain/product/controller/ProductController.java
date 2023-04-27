package com.ssafy.reslow.domain.product.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.product.dto.ProductRegistRequest;
import com.ssafy.reslow.domain.product.service.ProductService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@RequestMapping("/products")
@RestController
public class ProductController {

	private final ProductService productService;

	@PostMapping
	public Map<String, Object> registProduct(Authentication authentication,
		@RequestPart(value = "Regist") ProductRegistRequest request,
		@RequestPart List<MultipartFile> files)
		throws IOException {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		return productService.registProduct(principal, request, files);
	}
}
