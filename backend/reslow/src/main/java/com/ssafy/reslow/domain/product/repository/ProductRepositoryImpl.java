package com.ssafy.reslow.domain.product.repository;

import static com.querydsl.core.group.GroupBy.*;
import static com.ssafy.reslow.domain.product.entity.QProduct.*;
import static com.ssafy.reslow.domain.product.entity.QProductImage.*;
import static org.springframework.util.StringUtils.*;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.reslow.domain.product.dto.ProductListProjection;
import com.ssafy.reslow.domain.product.dto.QProductListProjection;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ProductRepositoryImpl implements ProductRepositoryCustom {

	private final JPAQueryFactory queryFactory;

	@Override
	public Slice<ProductListProjection> findByMemberIsNotAndCategoryAndKeyword(String keyword,
		Long category, Pageable pageable) {
		List<ProductListProjection> result = queryFactory
			.selectFrom(product)
			.leftJoin(product.productImages, productImage)
			.where(
				(hasText(keyword) ? product.title.contains(keyword) : null),
				category == null ? null : product.productCategory.no.eq(category),
				product.order.isNull()
			)
			.transform(
				groupBy(product.no).list(
					new QProductListProjection(
						product.member.no,
						product.no,
						product.title,
						product.price,
						product.createdDate,
						list(productImage.url)
					)
				)
			);
		boolean hasNext = false;
		if (result.size() > pageable.getPageSize()) {
			result.remove(pageable.getPageSize());
			hasNext = true;
		}
		return new SliceImpl<>(result, pageable, hasNext);
	}
}
