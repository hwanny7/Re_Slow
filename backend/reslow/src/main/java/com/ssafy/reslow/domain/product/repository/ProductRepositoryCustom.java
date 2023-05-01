package com.ssafy.reslow.domain.product.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;

import com.ssafy.reslow.domain.product.dto.ProductListProjection;

public interface ProductRepositoryCustom {
	Slice<ProductListProjection> findByMemberIsNotAndCategoryAndKeyword(String keyword, Long category,
		Pageable pageable);
}
