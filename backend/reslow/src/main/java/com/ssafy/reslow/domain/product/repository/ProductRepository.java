package com.ssafy.reslow.domain.product.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.product.entity.Product;

public interface ProductRepository extends JpaRepository<Product, Long> {
	Slice<Product> findByMemberAndStock(Member member, int stock, Pageable pageable);
	Slice<Product> findByMemberAndStockNot(Member member, int stock, Pageable pageable);
}
