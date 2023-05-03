package com.ssafy.reslow.domain.product.repository;

import com.ssafy.reslow.domain.product.dto.ProductListResponse;
import java.util.List;
import org.springframework.data.domain.Pageable;

public interface ProductRepositoryCustom {

    List<ProductListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword,
        Long category,
        Pageable pageable);
}
