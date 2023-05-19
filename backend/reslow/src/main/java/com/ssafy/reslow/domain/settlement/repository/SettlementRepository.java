package com.ssafy.reslow.domain.settlement.repository;

import java.time.LocalDateTime;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.settlement.entity.Settlement;

public interface SettlementRepository extends JpaRepository<Settlement, Long> {
	Slice<Settlement> findByMemberAndCreatedDateBetweenOrderByCreatedDateDesc(Member member, LocalDateTime startDt, LocalDateTime endDt, Pageable pageable);

	@Query("select sum(s.amount) from Settlement s where s.member=:member and s.createdDate between :startDt and :endDt")
	Integer sumAmountByMemberAndCreatedDateBetween(Member member, LocalDateTime startDt, LocalDateTime endDt);

	@Query("select sum(s.amount) from Settlement s where s.member=:member")
	Integer sumAmountByMember(Member member);
}
