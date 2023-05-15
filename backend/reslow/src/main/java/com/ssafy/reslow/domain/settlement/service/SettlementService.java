package com.ssafy.reslow.domain.settlement.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.settlement.dto.SettlementListResponse;
import com.ssafy.reslow.domain.settlement.entity.Settlement;
import com.ssafy.reslow.domain.settlement.repository.SettlementRepository;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class SettlementService {

	private final SettlementRepository settlementRepository;
	private final MemberRepository memberRepository;

	public Slice<SettlementListResponse> getSettlementList(Long memberNo, LocalDate startDate, LocalDate endDate, Pageable pageable) {
		LocalDateTime startDt = startDate.atStartOfDay();
		LocalDateTime endDt = endDate.atTime(LocalTime.MAX);
		Member member = memberRepository.getReferenceById(memberNo);
		Slice<Settlement> settlementSlice = settlementRepository.findByMemberAndCreatedDateBetween(member, startDt, endDt, pageable);
		List<SettlementListResponse> list = settlementSlice.getContent()
			.stream()
			.map(SettlementListResponse::of)
			.collect(Collectors.toList());
		return new SliceImpl<>(list, pageable, settlementSlice.hasNext());
	}

	public Map<String, Object> getAmount(Long memberNo, LocalDate startDate, LocalDate endDate) {
		Member member = memberRepository.getReferenceById(memberNo);
		Integer amount;

		if(startDate==null && endDate==null){
			amount = settlementRepository.sumAmountByMember(member);
		}
		else {
			LocalDateTime startDt = startDate.atStartOfDay();
			LocalDateTime endDt = endDate.atTime(LocalTime.MAX);
			amount = settlementRepository.sumAmountByMemberAndCreatedDateBetween(member, startDt, endDt);
		}
		if(amount == null) amount=0;

		Map<String, Object> map = new HashMap<>();
		map.put("amount", amount);
		return map;
	}
}
