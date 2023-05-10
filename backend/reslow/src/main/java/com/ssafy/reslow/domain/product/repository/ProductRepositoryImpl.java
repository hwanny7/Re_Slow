package com.ssafy.reslow.domain.product.repository;

import static com.ssafy.reslow.domain.product.entity.QProduct.*;
import static com.ssafy.reslow.domain.product.entity.QProductImage.*;
import static org.springframework.util.StringUtils.*;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import com.querydsl.core.QueryResults;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.reslow.domain.product.dto.ProductListResponse;
import com.ssafy.reslow.domain.product.entity.Product;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ProductRepositoryImpl implements ProductRepositoryCustom {

	private final JPAQueryFactory queryFactory;

	@Override
	public List<ProductListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword,
		Long category, Pageable pageable) {
		QueryResults<Product> result = queryFactory
			.selectFrom(product)
			.leftJoin(product.productImages, productImage)
			.where(
				(hasText(keyword) ? product.title.contains(keyword) : null),
				(hasText(keyword) ? product.description.contains(keyword) : null),
				category == null ? null : product.productCategory.no.eq(category),
				product.order.isNull()
			)
			.orderBy(product.createdDate.desc())
			.distinct()
			.offset(pageable.getOffset())
			.limit(pageable.getPageSize())
			.fetchResults();
		List<Product> products = result.getResults();
		List<ProductListResponse> list = products.stream()
			.map(product -> ProductListResponse.of(product, product.getProductImages()))
			.collect(Collectors.toList());
		return list;
	}
}
