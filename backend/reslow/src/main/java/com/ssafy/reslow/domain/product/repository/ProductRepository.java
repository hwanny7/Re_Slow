package com.ssafy.reslow.domain.product.repository;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import com.ssafy.reslow.domain.product.dto.ProductListResponse;
import com.ssafy.reslow.domain.product.entity.Product;
import com.ssafy.reslow.domain.product.entity.ProductCategory;
import java.util.List;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    @Query("SELECT p from Product p left join p.order o where p.member.no = :no and (p.order.no IS NULL or o.status = :status) GROUP BY p.no ORDER BY p.updatedDate DESC")
    Slice<Product> findByMemberAndOrder_StatusOrOrderIsNullOrderByUpdatedDateDesc(Long no,
        OrderStatus status,
        Pageable pageable);

    Slice<Product> findByMemberAndOrder_StatusIsGreaterThanEqualOrderByUpdatedDateDesc(
        Member member,
        OrderStatus status,
        Pageable pageable);

    Slice<Product> findByMemberAndOrder_StatusOrderByUpdatedDateDesc(Member member,
        OrderStatus status,
        Pageable pageable);

    List<ProductListResponse> findByMemberIsNotAndCategoryAndKeyword(String keyword, Long category,
        Pageable pageable);

    List<Product> findByNoIn(List<Long> pkList);

    List<Product> findTop10ByOrderIsNullOrderByCreatedDateDesc();

    List<Product> findTop10ByOrderIsNullAndProductCategoryOrProductCategoryOrderByCreatedDateDesc(
        ProductCategory category1, ProductCategory category2);
}
