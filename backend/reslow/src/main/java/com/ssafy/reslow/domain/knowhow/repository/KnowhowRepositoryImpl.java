package com.ssafy.reslow.domain.knowhow.repository;

import static com.ssafy.reslow.domain.knowhow.entity.QKnowhow.*;
import static com.ssafy.reslow.domain.knowhow.entity.QKnowhowContent.*;
import static org.springframework.util.StringUtils.*;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import com.querydsl.core.QueryResults;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowListResponse;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowContent;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class KnowhowRepositoryImpl implements KnowhowRepositoryCustom {
	private final JPAQueryFactory queryFactory;

	@Override
	public List<KnowhowListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword, Long category,
		Pageable pageable) {
		QueryResults<Knowhow> results = queryFactory.selectFrom(knowhow)
			.leftJoin(knowhow.knowhowContents, knowhowContent)
			.where(
				(hasText(keyword) ? knowhow.title.contains(keyword) : null),
				category == null ? null : knowhow.knowhowCategory.no.eq(category)
			)
			.distinct()
			.offset(pageable.getOffset())
			.limit(pageable.getPageSize())
			.fetchResults();

		List<Knowhow> knowhows = results.getResults();
		List<KnowhowListResponse> list = knowhows.stream()
			.map(x -> KnowhowListResponse.of(x, getImages(x).subList(0, Math.min(getImages(x).size(), 4)),
				getImages(x).size(),
				1L, (long)x.getKnowhowComments().size()))
			.collect(
				Collectors.toList());

		boolean hasNext = false;
		if (list.size() > pageable.getPageSize()) {
			list.remove(pageable.getPageSize());
			hasNext = true;
		}

		return list;
	}

	private List<String> getImages(Knowhow knowhow) {
		List<KnowhowContent> contents = knowhow.getKnowhowContents();
		List<String> images = contents.stream()
			.map(KnowhowContent::getImage)
			.filter(image -> image != null && !image.isEmpty())
			.collect(Collectors.toList());
		return images;
	}

}
