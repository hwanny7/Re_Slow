package com.ssafy.reslow.domain.product.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import com.ssafy.reslow.domain.product.dto.ProductListResponse;
import com.ssafy.reslow.domain.product.entity.Product;
import com.ssafy.reslow.domain.product.entity.ProductCategory;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

	Slice<Product> findByMemberAndOrder_StatusOrOrderIsNullOrderByCreatedDate(Member member, OrderStatus status,
		Pageable pageable);

	Slice<Product> findByMemberAndOrder_StatusIsGreaterThanEqualOrderByCreatedDate(Member member, OrderStatus status,
		Pageable pageable);

	Slice<Product> findByMemberAndOrder_StatusOrderByCreatedDate(Member member, OrderStatus status,
		Pageable pageable);

	List<ProductListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword, Long category,
		Pageable pageable);

	List<Product> findByNoIn(List<Long> pkList);

	List<Product> findTop10ByAndOrderIsNotNullOrderByCreatedDate();
	List<Product> findTop10ByAndOrderIsNotNullAAndProductCategoryOrderOrProductCategoryByCreatedDate(ProductCategory category1, ProductCategory category2);

	Product findTopBy1OrderIsNotNullOrderByCreatedDate();
}
