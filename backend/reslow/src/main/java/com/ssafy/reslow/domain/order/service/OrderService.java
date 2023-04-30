package com.ssafy.reslow.domain.order.service;

import static com.ssafy.reslow.domain.order.entity.OrderStatus.*;
import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.order.dto.OrderListResponse;
import com.ssafy.reslow.domain.order.dto.OrderRegistRequest;
import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import com.ssafy.reslow.domain.order.repository.OrderRepository;
import com.ssafy.reslow.domain.product.entity.Product;
import com.ssafy.reslow.domain.product.repository.ProductRepository;
import com.ssafy.reslow.global.exception.CustomException;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class OrderService {

	private final MemberRepository memberRepository;
	private final OrderRepository orderRepository;
	private final ProductRepository productRepository;

	public Slice<OrderListResponse> myOrderList(Long memberNo, int status, Pageable pageable) {
		Member member = memberRepository.findById(memberNo).get();
		Slice<Order> list = null;
		if (status == COMPLETE_DELIVERY.getValue()) {
			list = orderRepository.findByBuyerAndStatusIsGreaterThanEqual(member, OrderStatus.ofValue(status),
				pageable);
		} else {
			list = orderRepository.findByBuyerAndStatus(member, OrderStatus.ofValue(status), pageable);
		}

		List<OrderListResponse> responses = new ArrayList<>();
		list.stream().forEach(
			order -> {
				Product product = order.getProduct();
				String imageResource =
					product.getProductImages().isEmpty() ? null : product.getProductImages().get(0).getUrl();
				responses.add(OrderListResponse.of(product, order, imageResource, order.getStatus().getValue()));
			}
		);
		return new SliceImpl<>(responses, pageable, list.hasNext());
	}

	public Map<String, Long> registOrder(Long memberNo, OrderRegistRequest request) {
		Product product = productRepository.findById(request.getProductNo())
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		Order order = Order.of(request, product, member);
		Order savedOrder = orderRepository.save(order);
		Map<String, Long> map = new HashMap<>();
		map.put("orderNo", savedOrder.getNo());
		return map;
	}
}
