package com.ssafy.reslow.domain.knowhow.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowContent;

@Repository
public interface KnowhowContentRepository extends JpaRepository<KnowhowContent, Long> {
	Optional<List<KnowhowContent>> findKnowhowContentsByKnowhow(Knowhow knowhow);
}
