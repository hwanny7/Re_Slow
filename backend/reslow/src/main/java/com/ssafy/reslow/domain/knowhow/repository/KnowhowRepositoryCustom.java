package com.ssafy.reslow.domain.knowhow.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowRecommendRequest;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;

public interface KnowhowRepositoryCustom {
	List<Knowhow> findByKeywordsAndCategory(KnowhowRecommendRequest keywords, Long category,
		Pageable pageable);
}
