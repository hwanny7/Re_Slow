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

import com.siot.IamportRestClient.response.Payment;
import com.ssafy.reslow.domain.coupon.entity.IssuedCoupon;
import com.ssafy.reslow.domain.coupon.repository.IssuedCouponRepository;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.order.dto.OrderComfirmationResponse;
import com.ssafy.reslow.domain.order.dto.OrderListResponse;
import com.ssafy.reslow.domain.order.dto.OrderRegistRequest;
import com.ssafy.reslow.domain.order.dto.OrderUpdateCarrierRequest;
import com.ssafy.reslow.domain.order.dto.OrderUpdateStatusRequest;
import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import com.ssafy.reslow.domain.order.repository.OrderRepository;
import com.ssafy.reslow.domain.product.entity.Product;
import com.ssafy.reslow.domain.product.repository.ProductRepository;
import com.ssafy.reslow.global.exception.CustomException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@Transactional
@RequiredArgsConstructor
public class OrderService {

	private final MemberRepository memberRepository;
	private final OrderRepository orderRepository;
	private final ProductRepository productRepository;
	private final IssuedCouponRepository issuedCouponRepository;
	private final PaymentService paymentService;

	public Slice<OrderListResponse> myOrderList(Long memberNo, int status, Pageable pageable) {
		Member member = memberRepository.findById(memberNo).get();
		Slice<Order> list = null;
		if (status == COMPLETE_DELIVERY.getValue()) {
			list = orderRepository.findByBuyerAndStatusIsGreaterThanEqualOrderByUpdatedDateDesc(member,
				OrderStatus.ofValue(status),
				pageable);
		} else {
			list = orderRepository.findByBuyerAndStatusOrderByUpdatedDateDesc(member, OrderStatus.ofValue(status),
				pageable);
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

	@Transactional
	public Map<String, Long> registOrder(String imp_uid, Long memberNo, OrderRegistRequest request) {
		Payment payment = paymentService.getPayment(imp_uid);
		if (!payment.getStatus().equals("paid")) {
			throw new CustomException(PAYMENT_FAILED);
		}
		Product product = productRepository.findById(request.getProductNo())
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		Member member = memberRepository.findById(memberNo)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		IssuedCoupon issuedCoupon = null;
		if (request.getIssuedCouponNo() != null) {
			issuedCoupon = issuedCouponRepository.findById(request.getIssuedCouponNo())
				.orElseThrow(() -> new CustomException(COUPON_NOT_FOUND));
			issuedCoupon.use();
		}
		Order order = Order.of(request, product, member, issuedCoupon);
		Order savedOrder = orderRepository.save(order);
		product.setOrder(order);
		Map<String, Long> map = new HashMap<>();
		map.put("orderNo", savedOrder.getNo());
		return map;
	}

	@Transactional
	public Map<String, Long> updateStatus(Long orderNo, OrderUpdateStatusRequest request) {
		Order order = orderRepository.findById(orderNo)
			.orElseThrow(() -> new CustomException(ORDER_NOT_FOUND));

		if(request.getStatus() == ORDER_CANCEL.getValue()){
			System.out.println("!!!");
			orderRepository.deleteById(orderNo);
		} else {
			order.updateStatus(OrderStatus.ofValue(request.getStatus()));
		}
		Map<String, Long> map = new HashMap<>();
		map.put("orderNo", orderNo);
		return map;
	}

	@Transactional
	public Map<String, Long> updateCarrier(Long orderNo, OrderUpdateCarrierRequest request) {
		Order order = orderRepository.findById(orderNo)
			.orElseThrow(() -> new CustomException(ORDER_NOT_FOUND));
		order.updateCarrier(request);
		Map<String, Long> map = new HashMap<>();
		map.put("orderNo", orderNo);
		return map;
	}

	public OrderComfirmationResponse orderConfirmation(Long orderNo) {
		Order order = orderRepository.findById(orderNo)
			.orElseThrow(() -> new CustomException(ORDER_NOT_FOUND));
		OrderComfirmationResponse response = OrderComfirmationResponse.of(order.getProduct(), order);
		return response;
	}
}
