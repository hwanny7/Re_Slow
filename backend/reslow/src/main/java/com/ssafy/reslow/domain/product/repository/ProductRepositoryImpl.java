package com.ssafy.reslow.domain.product.repository;

import static com.ssafy.reslow.domain.product.entity.QProduct.product;
import static com.ssafy.reslow.domain.product.entity.QProductImage.productImage;
import static org.springframework.util.StringUtils.hasText;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.QueryResults;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.core.types.dsl.NumberTemplate;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.reslow.domain.product.dto.ProductListResponse;
import com.ssafy.reslow.domain.product.entity.Product;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class ProductRepositoryImpl implements ProductRepositoryCustom {

    private final JPAQueryFactory queryFactory;

    @Override
    public List<ProductListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword,
        Long category, Pageable pageable) {
        BooleanBuilder builder = new BooleanBuilder();
        NumberTemplate booleanTemplate = Expressions.numberTemplate(Double.class,
            "function('match', {0},{1})",
            product.description,
            keyword);
        builder.and(booleanTemplate.gt(0));
        QueryResults<Product> result = queryFactory
            .selectFrom(product)
            .leftJoin(product.productImages, productImage)
            .where(
                (hasText(keyword) ? product.title.contains(keyword) : null),
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
