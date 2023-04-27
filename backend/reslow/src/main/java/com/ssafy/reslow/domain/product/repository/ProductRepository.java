package com.ssafy.reslow.domain.product.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.product.entity.Product;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

}
