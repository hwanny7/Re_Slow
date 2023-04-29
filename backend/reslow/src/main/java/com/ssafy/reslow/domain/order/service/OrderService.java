package com.ssafy.reslow.domain.order.service;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.order.dto.OrderListResponse;
import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import com.ssafy.reslow.domain.order.repository.OrderRepository;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class OrderService {

	private final MemberRepository memberRepository;
	private final OrderRepository orderRepository;

	public Slice<OrderListResponse> myOrderList(Long memberNo, int status, Pageable pageable) {
		Member member = memberRepository.findById(memberNo).get();
		Slice<Order> list = orderRepository.findByBuyerAndStatus(member, OrderStatus.ofValue(status), pageable);
		Slice<OrderListResponse> responses = list.map(
			(order) -> OrderListResponse.of(order.getProduct(), order,
				order.getProduct().getProductImages().get(0).getUrl()));
		return responses;
	}
}
