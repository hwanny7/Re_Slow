package com.ssafy.reslow.domain.product.repository;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import com.ssafy.reslow.domain.product.dto.ProductListResponse;
import com.ssafy.reslow.domain.product.entity.Product;
import java.util.List;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    Slice<Product> findByMemberAndOrder_StatusOrOrderIsNull(Member member, OrderStatus status,
        Pageable pageable);

    Slice<Product> findByMemberAndOrder_StatusIsGreaterThanEqual(Member member, OrderStatus status,
        Pageable pageable);

    Slice<Product> findByMemberAndOrder_Status(Member member, OrderStatus status,
        Pageable pageable);

    List<ProductListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword, Long category,
        Pageable pageable);

    List<Product> findByNoIn(List<Long> pkList);
}
