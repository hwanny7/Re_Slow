package com.ssafy.reslow.domain.order.controller;

import java.util.Map;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.reslow.domain.order.dto.OrderComfirmationResponse;
import com.ssafy.reslow.domain.order.dto.OrderListResponse;
import com.ssafy.reslow.domain.order.dto.OrderRegistRequest;
import com.ssafy.reslow.domain.order.dto.OrderUpdateCarrierRequest;
import com.ssafy.reslow.domain.order.dto.OrderUpdateStatusRequest;
import com.ssafy.reslow.domain.order.service.OrderService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("orders")
@RequiredArgsConstructor
public class OrderController {

	private final OrderService orderService;

	@GetMapping("/purchase")
	public Slice<OrderListResponse> myOrderList(Authentication authentication, @RequestParam("status") int status,
		Pageable pageable) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return orderService.myOrderList(memberNo, status, pageable);
	}

	@PostMapping
	public Map<String, Long> registOrder(Authentication authentication, @RequestBody
	OrderRegistRequest request) {
		UserDetails principal = (UserDetails)authentication.getPrincipal();
		Long memberNo = Long.parseLong(principal.getUsername());
		return orderService.registOrder(memberNo, request);
	}

	@PatchMapping("/{orderNo}")
	public Map<String, Long> updateStatus(@PathVariable("orderNo") Long orderNo,
		@RequestBody OrderUpdateStatusRequest request) {
		return orderService.updateStatus(orderNo, request);
	}

	@GetMapping("/{orderNo}")
	public OrderComfirmationResponse orderConfirmation(@PathVariable("orderNo") Long orderNo) {
		return orderService.orderConfirmation(orderNo);
	}

	@PatchMapping("/{orderNo}/carrier")
	public Map<String, Long> updateCarrier(@PathVariable("orderNo") Long orderNo,
		@RequestBody OrderUpdateCarrierRequest request) {
		return orderService.updateCarrier(orderNo, request);
	}
}
