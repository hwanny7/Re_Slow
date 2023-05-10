package com.ssafy.reslow.domain.order.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.order.entity.OrderStatus;

public interface OrderRepository extends JpaRepository<Order, Long> {
	Slice<Order> findByBuyerAndStatusIsGreaterThanEqualOrderByUpdatedDateDesc(Member member, OrderStatus status,
		Pageable pageable);

	Slice<Order> findByBuyerAndStatusOrderByUpdatedDateDesc(Member member, OrderStatus ofValue, Pageable pageable);

	boolean existsByBuyer(Member member);

	Order findTop1ByBuyerOrderByCreatedDateDesc(Member member);
}
