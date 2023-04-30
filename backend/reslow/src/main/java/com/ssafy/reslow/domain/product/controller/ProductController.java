package com.ssafy.reslow.domain.product.controller;

import java.io.IOException;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.knowhow.service.KnowhowService;
import com.ssafy.reslow.domain.product.dto.MyProductListResponse;
import com.ssafy.reslow.domain.product.dto.ProductDetailResponse;
import com.ssafy.reslow.domain.product.dto.ProductListResponse;
import com.ssafy.reslow.domain.product.dto.ProductRegistRequest;
import com.ssafy.reslow.domain.product.dto.ProductUpdateRequest;
import com.ssafy.reslow.domain.product.service.ProductService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("products")
@RequiredArgsConstructor
public class ProductController {

	private final KnowhowService knowhowService;
	private final ProductService productService;

	@PostMapping
	public Map<String, Long> registProduct(Authentication authentication,
		@RequestPart(value = "Regist") ProductRegistRequest request,
		@RequestPart List<MultipartFile> files)
		throws IOException {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		return productService.registProduct(principal, request, files);
	}

	@PostMapping("/{productNo}")
	public ProductDetailResponse updateProduct(Authentication authentication, @PathVariable("productNo") Long productNo,
		@RequestPart(value = "Update") ProductUpdateRequest request,
		@RequestPart List<MultipartFile> files)
		throws IOException {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return productService.updateProduct(memberNo, productNo, request, files);
	}

	@DeleteMapping("/{productNo}")
	public Map<String, Long> deleteProduct(Authentication authentication, @PathVariable("productNo") Long productNo) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return productService.deleteroduct(memberNo, productNo);
	}

	@GetMapping("/{productNo}")
	public ProductDetailResponse productDetail(@PathVariable("productNo") Long productNo) {
		return productService.productDetail(productNo);
	}

	@GetMapping
	public Slice<ProductListResponse> productList(
		Authentication authentication,
		@RequestParam(required = false) String keyword,
		@RequestParam(required = false) Long category, Pageable pageable) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return productService.productList(memberNo, keyword, category, pageable);
	}

	@GetMapping("/sale")
	public Slice<MyProductListResponse> myProductList(Authentication authentication, @RequestParam("status") int status,
		Pageable pageable) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return productService.myProductList(memberNo, status, pageable);
	}

	@PostMapping("/{productNo}/like")
	public Map<String, Long> likeProduct(Authentication authentication, @PathVariable("productNo") Long
		productNo
	) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return knowhowService.likeKnowhow(memberNo, productNo);
	}

	@DeleteMapping("/{productNo}/like")
	public Map<String, Long> unlikeProduct(Authentication authentication, @PathVariable("productNo") Long
		productNo
	) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return knowhowService.unlikeKnowhow(memberNo, productNo);
	}
}
