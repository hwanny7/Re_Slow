package com.ssafy.reslow.domain.product.service;

import static com.ssafy.reslow.domain.order.entity.OrderStatus.*;
import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import com.ssafy.reslow.domain.order.repository.OrderRepository;
import com.ssafy.reslow.domain.product.dto.MyProductListResponse;
import com.ssafy.reslow.domain.product.dto.ProductDetailResponse;
import com.ssafy.reslow.domain.product.dto.ProductListResponse;
import com.ssafy.reslow.domain.product.dto.ProductRecommendResponse;
import com.ssafy.reslow.domain.product.dto.ProductRegistRequest;
import com.ssafy.reslow.domain.product.dto.ProductUpdateRequest;
import com.ssafy.reslow.domain.product.dto.ProductUpdateResponse;
import com.ssafy.reslow.domain.product.entity.Product;
import com.ssafy.reslow.domain.product.entity.ProductCategory;
import com.ssafy.reslow.domain.product.entity.ProductImage;
import com.ssafy.reslow.domain.product.repository.ProductCategoryRepository;
import com.ssafy.reslow.domain.product.repository.ProductImageRepository;
import com.ssafy.reslow.domain.product.repository.ProductRepository;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.infra.storage.StorageServiceImpl;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class ProductService {

	private final MemberRepository memberRepository;
	private final ProductRepository productRepository;
	private final OrderRepository orderRepository;
	private final ProductCategoryRepository productCategoryRepository;
	private final ProductImageRepository productImageRepository;
	private final StorageServiceImpl s3Service;
	private final RedisTemplate redisTemplate;

	public Map<String, Long> registProduct(Long memberNo, ProductRegistRequest request,
		List<MultipartFile> files)
		throws IOException {
		Member member = memberRepository.findById(memberNo)
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

		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		zSetOperations.incrementScore("product", String.valueOf(savedProduct.getNo()), 0);

		Map<String, Long> map = new HashMap<>();
		map.put("productNo", savedProduct.getNo());
		return map;
	}

	public ProductUpdateResponse updateProduct(Long memberNo, Long productNo,
		ProductUpdateRequest request,
		List<MultipartFile> files) throws
		IOException {
		Product product = productRepository.findById(productNo)
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		ProductCategory productCategory = productCategoryRepository.findById(request.getCategory())
			.orElseThrow(() -> new CustomException(CATEGORY_NOT_FOUND));
		if (memberNo != product.getMember().getNo()) {
			throw new CustomException(USER_NOT_MATCH);
		}
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
		List<String> images = product.getProductImages().stream()
			.map((productImage) -> productImage.getUrl())
			.collect(Collectors.toList());
		ProductUpdateResponse updatedProduct = ProductUpdateResponse.of(product,
			product.getProductCategory().getCategory(), images);
		return updatedProduct;
	}

	public Map<String, Long> deleteProduct(Long memberNo, Long productNo) {
		Product product = productRepository.findById(productNo)
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		if (!memberNo.equals(product.getMember().getNo())) {
			throw new CustomException(USER_NOT_MATCH);
		}
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		setOperations.remove(String.valueOf(productNo));
		zSetOperations.remove(memberNo + "_like_product", String.valueOf(productNo));
		zSetOperations.remove(memberNo + "product", String.valueOf(productNo));
		zSetOperations.incrementScore("product_" + memberNo,
			String.valueOf(product.getProductCategory().getNo()),
			-1);
		productRepository.delete(product);
		Map<String, Long> map = new HashMap<>();
		map.put("productNo", productNo);
		return map;
	}

	public List<ProductListResponse> productList(Long memberNo, String keyword, Long category,
		Pageable pageable) {
		List<ProductListResponse> list = productRepository.findByMemberIsNotAndCategoryAndKeyword(
			keyword, category, pageable);
		list.forEach(product -> product.setLike(checkLiked(memberNo, product.getProductNo()),
			likeCount(product.getProductNo())));
		return list;
	}

	public ProductDetailResponse productDetail(Long memberNo, Long productNo) {
		Product product = productRepository.findById(productNo)
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		List<ProductImage> productImages = productImageRepository.findByProductNo(product.getNo());
		List<String> images = productImages.stream()
			.map((productImage) -> productImage.getUrl())
			.collect(Collectors.toList());
		boolean myHeart = checkLiked(memberNo, productNo);
		Long heartCount = likeCount(productNo);
		ProductDetailResponse productDetailResponse = ProductDetailResponse.of(product,
			product.getProductCategory()
				.getCategory(), product.getMember().getNo() == memberNo, myHeart, heartCount,
			images);
		return productDetailResponse;
	}

	public Slice<MyProductListResponse> myProductList(Long memberNo, int status,
		Pageable pageable) {
		Member member = memberRepository.findById(memberNo)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		Slice<Product> list = null;
		if (status == COMPLETE_PAYMENT.getValue()) {
			list = productRepository.findByMemberAndOrder_StatusOrOrderIsNullOrderByUpdatedDateDesc(
				member.getNo(),
				OrderStatus.ofValue(status),
				pageable);
		} else if (status == COMPLETE_DELIVERY.getValue()) {
			list = productRepository.findByMemberAndOrder_StatusIsGreaterThanEqualOrderByUpdatedDateDesc(
				member,
				OrderStatus.ofValue(status),
				pageable);
		} else {
			list = productRepository.findByMemberAndOrder_StatusOrderByUpdatedDateDesc(member,
				OrderStatus.ofValue(status), pageable);
		}

		List<MyProductListResponse> responses = new ArrayList<>();
		list.stream().forEach(
			product -> {
				Order order = product.getOrder();
				String imageResource =
					product.getProductImages().isEmpty() ? null
						: product.getProductImages().get(0).getUrl();
				if (status == COMPLETE_PAYMENT.getValue()) {
					responses.add(MyProductListResponse.of(product, imageResource,
						order == null ? 0 : order.getStatus().getValue()));
				} else if (order != null) {
					responses.add(MyProductListResponse.of(product, imageResource,
						order.getStatus().getValue()));
				}
			}
		);
		return new SliceImpl<>(responses, pageable, list.hasNext());
	}

	public List<ProductRecommendResponse> recommendProduct() {
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		Set<String> range = zSetOperations.reverseRange("product", 0, 9);
		List<ProductRecommendResponse> list = range.stream().map(productNo -> {
			Long no = Long.parseLong(productNo);
			Product product = productRepository.getReferenceById(no);
			return ProductRecommendResponse.of(product, likeCount(no));
		}).collect(Collectors.toList());
		return list;
	}

	public List<ProductRecommendResponse> recommendMyProduct(Long memberNo) {
		List<ProductRecommendResponse> list = null;
		if (memberNo == null) {
			list = productRepository.findTop10ByOrderIsNullOrderByCreatedDateDesc()
				.stream()
				.map(product -> {
					return ProductRecommendResponse.of(product, likeCount(product.getNo()));
				}).collect(Collectors.toList());
		} else {
			ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
			Member member = memberRepository.findById(memberNo)
				.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
			String myCategory = String.valueOf(zSetOperations.range("product_" + memberNo, 0, 0));
			myCategory = myCategory.substring(1, myCategory.length() - 1);
			ProductCategory myProductCategory = productCategoryRepository.findById(
					Long.parseLong(myCategory))
				.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
			ProductCategory category = null;
			if (orderRepository.existsByBuyer(member)) {
				category = orderRepository.findTop1ByBuyerOrderByCreatedDateDesc(member)
					.getProduct()
					.getProductCategory();
			}
			list = productRepository.findTop10ByOrderIsNullAndProductCategoryOrProductCategoryOrderByCreatedDateDesc(
					category, myProductCategory)
				.stream().map(product -> {
					return ProductRecommendResponse.of(product, likeCount(product.getNo()));
				}).collect(Collectors.toList());
		}
		return list;
	}

	public Map<String, Long> likeProduct(Long memberNo, Long productNo) {
		Product product = productRepository.findById(productNo)
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		String productString = String.valueOf(productNo);

		setOperations.add(productString, String.valueOf(memberNo));

		boolean added = zSetOperations.addIfAbsent(memberNo + "_like_product", productString,
			System.currentTimeMillis());
		if (added) {
			zSetOperations.incrementScore("product", productString, 1);
			zSetOperations.incrementScore("product_" + memberNo,
				String.valueOf(product.getProductCategory().getNo()),
				1);
		}

		Map<String, Long> map = new HashMap<>();
		map.put("count", (long)Math.floor(zSetOperations.score("product", productString)));
		return map;
	}

	public Map<String, Long> unlikeProduct(Long memberNo, Long productNo) {
		Product product = productRepository.findById(productNo)
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		String productString = String.valueOf(productNo);

		if (setOperations.isMember(productString, String.valueOf(memberNo)) == null) {
			throw new CustomException(MEMBER_NOT_FOUND);
		}
		setOperations.remove(productString, String.valueOf(memberNo));

		zSetOperations.remove(memberNo + "_like_product", productString);
		zSetOperations.incrementScore("product", productString, -1);
		zSetOperations.incrementScore("product_" + memberNo,
			String.valueOf(product.getProductCategory().getNo()), -1);

		Map<String, Long> map = new HashMap<>();
		map.put("count", (long)Math.floor(zSetOperations.score("product", productString)));
		return map;
	}

	public Slice<ProductListResponse> likeProductList(Long memberNo, Pageable pageable) {
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		String key = memberNo + "_like_product";
		int start = pageable.getPageNumber() * pageable.getPageSize();
		int end = start + pageable.getPageSize();

		List<Long> pkList = zSetOperations.reverseRange(key, start, end)
			.stream()
			.map(Long::parseLong)
			.collect(Collectors.toList());

		List<Product> productList = productRepository.findByNoIn(pkList);
		Collections.sort(productList, new Comparator<Product>() {
			@Override
			public int compare(Product o1, Product o2) {
				return pkList.indexOf(o1.getNo()) - pkList.indexOf(o2.getNo());
			}
		});

		List<ProductListResponse> productListResponseList = productList
			.stream()
			.map(product -> {
				Long likeCnt = likeCount(product.getNo());
				return ProductListResponse.of(product, likeCnt);
			})
			.collect(Collectors.toList());

		boolean hasNext = zSetOperations.size(key) > end + 1;
		return new SliceImpl<>(productListResponseList, pageable, hasNext);
	}

	public Long likeCount(Long productNo) {
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		return setOperations.size(String.valueOf(productNo));
	}

	public boolean checkLiked(Long memberNo, Long productNo) {
		if (memberNo == null) {
			return false;
		}
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		return setOperations.isMember(String.valueOf(productNo), String.valueOf(memberNo));
	}
}
