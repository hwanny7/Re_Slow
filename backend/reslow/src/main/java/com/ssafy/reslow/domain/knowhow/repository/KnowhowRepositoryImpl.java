package com.ssafy.reslow.domain.knowhow.repository;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowListResponse;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.QKnowhow;
import com.ssafy.reslow.domain.knowhow.entity.QKnowhowComment;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class KnowhowRepositoryImpl implements KnowhowRepositoryCustom {
	private final JPAQueryFactory queryFactory;

	@Override
	public List<KnowhowListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword, Long category,
		Pageable pageable) {

		QKnowhow knowhow = QKnowhow.knowhow;
		QKnowhowComment comment = QKnowhowComment.knowhowComment;

		List<Knowhow> knowhowList = queryFactory
			.selectFrom(knowhow)
			.leftJoin(knowhow.knowhowComments, comment)
			.where(knowhow.title.containsIgnoreCase(keyword)
					.or(knowhow.knowhowContents.any().content.containsIgnoreCase(keyword)),
				category == null ? null : knowhow.knowhowCategory.no.eq(category))
			.fetch();

		List<KnowhowListResponse> list = knowhowList.stream()
			.map(x -> KnowhowListResponse.of(x,
				1L, (long)x.getKnowhowComments().size(), false))
			.collect(
				Collectors.toList());

		return list;
	}
}
