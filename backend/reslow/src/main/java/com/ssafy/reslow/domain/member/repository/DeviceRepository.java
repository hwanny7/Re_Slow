package com.ssafy.reslow.domain.member.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.member.entity.Device;
import com.ssafy.reslow.domain.member.entity.Member;

@Repository
public interface DeviceRepository extends JpaRepository<Device, Long> {
	Optional<List<String>> findByMember(Member member);
}
