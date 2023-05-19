package com.ssafy.reslow.domain.order.repository;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository extends JpaRepository<Order, Long> {

    Slice<Order> findByBuyerAndStatusIsGreaterThanEqualOrderByUpdatedDateDesc(Member member,
        OrderStatus status,
        Pageable pageable);

    Slice<Order> findByBuyerAndStatusOrderByUpdatedDateDesc(Member member, OrderStatus status,
        Pageable pageable);

    boolean existsByBuyer(Member member);

    Order findTop1ByBuyerOrderByCreatedDateDesc(Member member);

    Page<Order> findByUpdatedDateLessThanAndStatus(LocalDateTime time, OrderStatus status, Pageable pageable);

    Page<Order> findByStatus(OrderStatus status, Pageable pageable);
}
