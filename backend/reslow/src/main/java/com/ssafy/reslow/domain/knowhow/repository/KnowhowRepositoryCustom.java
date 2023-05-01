package com.ssafy.reslow.domain.knowhow.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowList;

public interface KnowhowRepositoryCustom {
	List<KnowhowList> findByMemberIsNotAndCategoryAndKeyword(String keyword, Long category, Pageable pageable);
}
