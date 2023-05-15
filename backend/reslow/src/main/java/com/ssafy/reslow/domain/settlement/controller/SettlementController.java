package com.ssafy.reslow.domain.settlement.controller;

import java.time.LocalDate;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.settlement.dto.SettlementListResponse;
import com.ssafy.reslow.domain.settlement.service.SettlementService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("settlements")
@RequiredArgsConstructor
public class SettlementController {

	private final SettlementService settlementService;

	@GetMapping
	public Slice<SettlementListResponse> getSettlementList(
		Authentication authentication,
		@RequestParam(value="startDate", defaultValue="2023-01-01") LocalDate startDate,
		@RequestParam(value="endDate") LocalDate endDate,
		Pageable pageable) {
		Long memberNo = Long.parseLong(authentication.getName());
		if(endDate==null) endDate = LocalDate.now();
		return settlementService.getSettlementList(memberNo, startDate, endDate, pageable);
	}

}
