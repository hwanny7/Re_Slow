package com.ssafy.reslow.domain.notice.repository;

import java.util.Optional;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.notice.entity.Notice;

@Repository
public interface NoticeRepository extends JpaRepository<Notice, Long> {
	Optional<Notice> findBySenderAndTitle(String sender, String title);

	Slice<Notice> findByMemberOrderByAlertTimeDesc(Member member, Pageable pageable);

	@Modifying
	@Query("delete from Notice n where n.member=:member")
	void deleteAllByMember(Member member);
}
