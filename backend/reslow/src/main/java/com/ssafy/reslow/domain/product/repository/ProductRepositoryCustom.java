package com.ssafy.reslow.domain.product.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;

import com.ssafy.reslow.domain.product.dto.ProductListResponse;

public interface ProductRepositoryCustom {

	List<ProductListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword,
		Long category,
		Pageable pageable);
}
