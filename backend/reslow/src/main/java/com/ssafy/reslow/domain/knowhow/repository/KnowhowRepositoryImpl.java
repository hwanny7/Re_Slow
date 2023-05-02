package com.ssafy.reslow.domain.knowhow.repository;

import static com.ssafy.reslow.domain.knowhow.entity.QKnowhow.*;
import static com.ssafy.reslow.domain.knowhow.entity.QKnowhowContent.*;
import static org.springframework.util.StringUtils.*;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.QueryResults;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.core.types.dsl.NumberTemplate;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowListResponse;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class KnowhowRepositoryImpl implements KnowhowRepositoryCustom {
	private final JPAQueryFactory queryFactory;
	private final KnowhowCategoryRepository knowhowCategoryRepository;

	@Override
	public List<KnowhowListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword, Long category,
		Pageable pageable) {
		BooleanBuilder builder = new BooleanBuilder();
		NumberTemplate booleanTemplate = Expressions.numberTemplate(Double.class, "function('match', {0},{1})",
			knowhowContent,
			keyword);
		builder.and(booleanTemplate.gt(0));

		QueryResults<Knowhow> results = queryFactory.selectFrom(knowhow)
			.leftJoin(knowhow.knowhowContents, knowhowContent)
			.where(
				(hasText(keyword) ? knowhow.title.contains(keyword) : null),
				category == null ? null : knowhow.knowhowCategory.no.eq(category),
				builder
			)
			.distinct()
			.offset(pageable.getOffset())
			.limit(pageable.getPageSize())
			.fetchResults();

		List<Knowhow> knowhows = results.getResults();
		List<KnowhowListResponse> list = knowhows.stream()
			.map(x -> KnowhowListResponse.of(x,
				1L, (long)x.getKnowhowComments().size()))
			.collect(
				Collectors.toList());

		return list;
	}
}
