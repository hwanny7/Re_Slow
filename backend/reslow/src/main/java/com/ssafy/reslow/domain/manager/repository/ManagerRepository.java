package com.ssafy.reslow.domain.manager.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.reslow.domain.manager.entity.Manager;

@Repository
public interface ManagerRepository extends JpaRepository<Manager, Long> {

	Optional<Manager> findById(String id);
	boolean existsById(String Id);
}
