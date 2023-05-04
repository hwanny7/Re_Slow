package com.ssafy.reslow.domain.knowhow.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowRecommendRequest;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;

@Repository
public interface KnowhowRepository extends JpaRepository<Knowhow, Long>, KnowhowRepositoryCustom {
	Page<Knowhow> findAll(Pageable pageable);

	Page<Knowhow> findAllByMember_No(Pageable pageable, Long memberNo);

	List<Knowhow> findByMemberIsNotAndCategoryAndKeyword(KnowhowRecommendRequest keywords, Long category,
		Pageable pageable);

	List<Knowhow> findByNoIn(List<Long> pkList);
}
