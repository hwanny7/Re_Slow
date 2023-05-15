package com.ssafy.reslow.domain.settlement.repository;

import java.time.LocalDateTime;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.settlement.entity.Settlement;

public interface SettlementRepository extends JpaRepository<Settlement, Long> {
	Slice<Settlement> findByMemberAndCreatedDateGreaterThanEqualAndCreatedDateLessThanEqual(Member memberNo, LocalDateTime startDt, LocalDateTime endDt, Pageable pageable);
}
