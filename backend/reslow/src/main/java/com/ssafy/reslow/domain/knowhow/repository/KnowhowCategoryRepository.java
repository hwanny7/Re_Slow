package com.ssafy.reslow.domain.knowhow.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.knowhow.entity.KnowhowCategory;

@Repository
public interface KnowhowCategoryRepository extends JpaRepository<KnowhowCategory, Long> {
	Optional<KnowhowCategory> findByCategory(String category);
}
