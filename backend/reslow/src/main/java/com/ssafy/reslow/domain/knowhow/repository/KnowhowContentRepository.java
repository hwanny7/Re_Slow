package com.ssafy.reslow.domain.knowhow.repository;

import com.ssafy.reslow.domain.knowhow.entity.KnowhowContent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface KnowhowContentRepository extends JpaRepository<KnowhowContent, Long> {
}
