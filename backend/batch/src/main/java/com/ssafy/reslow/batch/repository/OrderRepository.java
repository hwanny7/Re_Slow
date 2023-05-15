package com.ssafy.reslow.batch.repository;

import com.ssafy.reslow.batch.entity.Order;
import com.ssafy.reslow.batch.entity.OrderStatus;
import java.time.LocalDateTime;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository extends JpaRepository<Order, Long> {

    Page<Order> findByUpdatedDateLessThanAndStatus(LocalDateTime time, OrderStatus status,
        Pageable pageable);

    Page<Order> findByStatus(OrderStatus status, Pageable pageable);
}
