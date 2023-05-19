package com.ssafy.reslow.domain.settlement.controller;

import java.time.LocalDate;
import java.util.Map;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.format.annotation.DateTimeFormat;
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
		@RequestParam(value="startDate") @DateTimeFormat(pattern = "yyyy-MM-dd")LocalDate startDate,
		@RequestParam(value="endDate") @DateTimeFormat(pattern = "yyyy-MM-dd")LocalDate endDate,
		Pageable pageable
	){
		Long memberNo = Long.parseLong(authentication.getName());
		return settlementService.getSettlementList(memberNo, startDate, endDate, pageable);
	}

	@GetMapping("/amount")
	public Map<String, Object> getAmount(
		Authentication authentication,
		@RequestParam(value="startDate", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd")LocalDate startDate,
		@RequestParam(value="endDate", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd")LocalDate endDate
	){
		Long memberNo = Long.parseLong(authentication.getName());
		return settlementService.getAmount(memberNo, startDate, endDate);
	}

}
