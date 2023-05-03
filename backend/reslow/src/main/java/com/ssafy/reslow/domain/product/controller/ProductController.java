package com.ssafy.reslow.domain.product.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.product.dto.MyProductListResponse;
import com.ssafy.reslow.domain.product.dto.ProductDetailResponse;
import com.ssafy.reslow.domain.product.dto.ProductListResponse;
import com.ssafy.reslow.domain.product.dto.ProductRegistRequest;
import com.ssafy.reslow.domain.product.dto.ProductUpdateRequest;
import com.ssafy.reslow.domain.product.dto.ProductUpdateResponse;
import com.ssafy.reslow.domain.product.service.ProductService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("products")
@RequiredArgsConstructor
public class ProductController {

	private final ProductService productService;

	@PostMapping
	public Map<String, Long> registProduct(Authentication authentication,
		@RequestParam String title,
		@RequestParam String description,
		@RequestParam int deliveryFee,
		@RequestParam int price,
		@RequestParam Long category,
		@RequestParam List<MultipartFile> files)
		throws IOException {
		Long memberNo = Long.parseLong(authentication.getName());
		ProductRegistRequest request = ProductRegistRequest.of(title, description, deliveryFee, price, category);
		return productService.registProduct(memberNo, request, files);
	}

	@PostMapping("/{productNo}")
	public ProductUpdateResponse updateProduct(Authentication authentication, @PathVariable("productNo") Long productNo,
		@RequestParam String title,
		@RequestParam String description,
		@RequestParam int deliveryFee,
		@RequestParam int price,
		@RequestParam Long category,
		@RequestParam Set<Long> productImages,
		@RequestPart List<MultipartFile> files)
		throws IOException {
		Long memberNo = Long.parseLong(authentication.getName());
		ProductUpdateRequest request = ProductUpdateRequest.of(title, description, deliveryFee, price, category,
			productImages);
		return productService.updateProduct(memberNo, productNo, request, files);
	}

	@DeleteMapping("/{productNo}")
	public Map<String, Long> deleteProduct(Authentication authentication, @PathVariable("productNo") Long productNo) {
		Long memberNo = Long.parseLong(authentication.getName());
		return productService.deleteProduct(memberNo, productNo);
	}

	@GetMapping("/{productNo}")
	public ProductDetailResponse productDetail(Authentication authentication,
		@PathVariable("productNo") Long productNo) {
		Long memberNo = Long.parseLong(authentication.getName());
		return productService.productDetail(memberNo, productNo);
	}

	@GetMapping
	public Slice<ProductListResponse> productList(
		Authentication authentication,
		@RequestParam(required = false) String keyword,
		@RequestParam(required = false) Long category, Pageable pageable) {
		Long memberNo = Long.parseLong(authentication.getName());
		return productService.productList(memberNo, keyword, category, pageable);
	}

	@GetMapping("/sale")
	public Slice<MyProductListResponse> myProductList(Authentication authentication, @RequestParam("status") int status,
		Pageable pageable) {
		Long memberNo = Long.parseLong(authentication.getName());
		return productService.myProductList(memberNo, status, pageable);
	}

	@PostMapping("/{productNo}/like")
	public Map<String, Long> likeProduct(Authentication authentication, @PathVariable("productNo") Long
		productNo
	) {
		Long memberNo = Long.parseLong(authentication.getName());
		return productService.likeProduct(memberNo, productNo);
	}

	@DeleteMapping("/{productNo}/like")
	public Map<String, Long> unlikeProduct(Authentication authentication, @PathVariable("productNo") Long
		productNo
	) {
		Long memberNo = Long.parseLong(authentication.getName());
		return productService.unlikeProduct(memberNo, productNo);
	}

	@GetMapping("/likes")
	public Slice<ProductListResponse> likeProductList(Authentication authentication, Pageable pageable) {
		Long memberNo = Long.parseLong(authentication.getName());
		return productService.likeProductList(memberNo, pageable);
	}

}
