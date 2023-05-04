package com.ssafy.reslow.domain.knowhow.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowRecommendRequest;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.QKnowhow;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class KnowhowRepositoryImpl implements KnowhowRepositoryCustom {
	private final JPAQueryFactory queryFactory;

	@Override
	public List<Knowhow> findByMemberIsNotAndCategoryAndKeyword(KnowhowRecommendRequest keywords, Long category,
		Pageable pageable) {

		QKnowhow knowhow = QKnowhow.knowhow;

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

		List<Knowhow> knowhowList = queryFactory.selectFrom(knowhow)
			.where(searchBuilder)
			.fetch();

		return knowhowList;
	}
}
