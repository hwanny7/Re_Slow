package com.ssafy.reslow.domain.product.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.product.dto.ProductRegistRequest;
import com.ssafy.reslow.domain.product.entity.Product;
import com.ssafy.reslow.domain.product.entity.ProductCategory;
import com.ssafy.reslow.domain.product.entity.ProductImage;
import com.ssafy.reslow.domain.product.repository.ProductCategoryRepository;
import com.ssafy.reslow.domain.product.repository.ProductImageRepository;
import com.ssafy.reslow.domain.product.repository.ProductRepository;
import com.ssafy.reslow.global.auth.jwt.JwtTokenProvider;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.infra.storage.S3StorageClient;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ProductService {

	private final MemberRepository memberRepository;
	private final ProductRepository productRepository;
	private final ProductCategoryRepository productCategoryRepository;
	private final ProductImageRepository productImageRepository;
	private final JwtTokenProvider jwtTokenProvider;
	private final AuthenticationManager authenticationManager;
	private final S3StorageClient s3Service;

	public Map<String, Object> registProduct(UserDetails user, ProductRegistRequest request, List<MultipartFile> files)
		throws IOException {
		Member member = memberRepository.findById(Long.parseLong(user.getUsername()))
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		ProductCategory productCategory = productCategoryRepository.findById(request.getCategory())
			.orElseThrow(() -> new CustomException(CATEGORY_NOT_FOUND));

		Product product = Product.of(member, request, productCategory);
		List<ProductImage> productImages = new ArrayList<>();
		for (MultipartFile file : files) {
			String imageSrc = s3Service.uploadFile(file);
			ProductImage productImage = ProductImage.of(product, imageSrc);
			productImages.add(productImage);
		}

		product.setProductImages(productImages);
		Product savedProduct = productRepository.save(product);
		Map<String, Object> map = new HashMap<>();
		map.put("productId", savedProduct.getNo());
		return map;
	}
}
