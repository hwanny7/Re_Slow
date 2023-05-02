package com.ssafy.reslow.domain.knowhow.repository;

import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface KnowhowCategoryRepository extends JpaRepository<KnowhowCategory, Long> {
}
