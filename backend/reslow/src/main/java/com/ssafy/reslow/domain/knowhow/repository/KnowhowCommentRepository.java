package com.ssafy.reslow.domain.knowhow.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.knowhow.entity.KnowhowComment;

@Repository
public interface KnowhowCommentRepository extends JpaRepository<KnowhowComment, Long> {
    Slice<KnowhowComment> findByKnowhowNoAndParentIsNull(Long knowhowNo, Pageable pageable);
}
