package com.ssafy.reslow.domain.knowhow.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowListResponse;

public interface KnowhowRepositoryCustom {
	List<KnowhowListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword, Long category, Pageable pageable);
}
