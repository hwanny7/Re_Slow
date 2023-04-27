package com.ssafy.reslow.domain.product.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.product.dto.ProductRegistRequest;
import com.ssafy.reslow.domain.product.dto.ProductUpdateRequest;
import com.ssafy.reslow.domain.product.dto.ProductUpdateResponse;
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

@Service
@Transactional
@RequiredArgsConstructor
public class ProductService {

	private final MemberRepository memberRepository;
	private final ProductRepository productRepository;
	private final ProductCategoryRepository productCategoryRepository;
	private final ProductImageRepository productImageRepository;
	private final JwtTokenProvider jwtTokenProvider;
	private final AuthenticationManager authenticationManager;
	private final S3StorageClient s3Service;
	private final RedisTemplate redisTemplate;

	public Map<String, Long> likeProduct(Long memberNo, Long productNo) {
		SetOperations<Object, Long> setOperations = redisTemplate.opsForSet();
		setOperations.add(productNo, memberNo);
		setOperations.add(memberNo + "_like_product", productNo);

		Map<String, Long> map = new HashMap<>();
		map.put("count", setOperations.size(productNo));
		return map;
	}

	public Map<String, Long> unlikeProduct(Long memberNo, Long productNo) {
		SetOperations<Object, Long> setOperations = redisTemplate.opsForSet();
		setOperations.remove(productNo, memberNo);
		setOperations.remove(memberNo + "_like_product", productNo);

		Map<String, Long> map = new HashMap<>();
		map.put("count", setOperations.size(productNo));
		return map;
	}

	public Map<String, Long> registProduct(UserDetails user, ProductRegistRequest request, List<MultipartFile> files)
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
		Map<String, Long> map = new HashMap<>();
		map.put("productId", savedProduct.getNo());
		return map;
	}

	public ProductUpdateResponse updateProduct(UserDetails user, Long productNo, ProductUpdateRequest request,
		List<MultipartFile> files) throws
		IOException {
		Member member = memberRepository.findById(Long.parseLong(user.getUsername()))
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		Product product = productRepository.findById(productNo)
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		ProductCategory productCategory = productCategoryRepository.findById(request.getCategory())
			.orElseThrow(() -> new CustomException(CATEGORY_NOT_FOUND));
		product.updateProduct(request, productCategory);

		List<ProductImage> productImages = productImageRepository.findByProductNo(product.getNo());
		List<ProductImage> newImages = new ArrayList<>();
		Set<Long> newImageNoSet = request.getProductImages();
		for (ProductImage img : productImages) {
			if (!newImageNoSet.contains(img.getNo())) {
				s3Service.deleteFile(img.getUrl());
				productImageRepository.deleteById(img.getNo());
			} else {
				newImages.add(img);
			}
		}
		for (MultipartFile file : files) {
			if (!file.isEmpty()) {
				String imageSrc = s3Service.uploadFile(file);
				ProductImage productImage = ProductImage.builder()
					.product(product)
					.url(imageSrc)
					.build();
				newImages.add(productImage);
			}
		}
		product.setProductImages(newImages);

		productRepository.save(product);
		ProductUpdateResponse updatedProduct = ProductUpdateResponse.of(product,
			product.getProductCategory().getCategory());
		return updatedProduct;
	}

	public Map<String, Long> deleteroduct(Long memberNo, Long productNo) {
		Product product = productRepository.findById(productNo)
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		productRepository.delete(product);
		Map<String, Long> map = new HashMap<>();
		map.put("productId", productNo);
		return map;
	}
}
