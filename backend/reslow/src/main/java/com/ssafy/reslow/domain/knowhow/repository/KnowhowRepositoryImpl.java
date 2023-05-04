package com.ssafy.reslow.domain.knowhow.repository;

import static com.ssafy.reslow.domain.knowhow.entity.QKnowhow.*;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowRecommendRequest;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class KnowhowRepositoryImpl implements KnowhowRepositoryCustom {
	private final JPAQueryFactory queryFactory;

	@Override
	public List<Knowhow> findByMemberIsNotAndCategoryAndKeyword(KnowhowRecommendRequest keywords, Long category,
		Pageable pageable) {

		BooleanBuilder searchBuilder = null;

		for (String keyword : keywords.getKeywords()) {
			BooleanBuilder keywordBuilder = new BooleanBuilder();
			keywordBuilder.and(knowhow.title.containsIgnoreCase(keyword)
				.or(knowhow.knowhowContents.any().content.containsIgnoreCase(keyword)));

			if (searchBuilder == null) {
				searchBuilder = keywordBuilder;
			} else {
				searchBuilder = searchBuilder.and(keywordBuilder);
			}
		}

		return queryFactory.selectFrom(knowhow)
			.where(searchBuilder, category == null ? null : knowhow.knowhowCategory.no.eq(category))
			.orderBy(knowhow.createdDate.desc())
			.offset(pageable.getOffset())   // 페이지 번호
			.limit(pageable.getPageSize())  // 페이지 사이즈
			.fetch();

	}
}
