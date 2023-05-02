package com.ssafy.reslow.domain.manager.service;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.ssafy.reslow.domain.manager.entity.Manager;
import com.ssafy.reslow.domain.manager.repository.ManagerRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomManagerDetailService implements UserDetailsService {

	private final ManagerRepository managerRepository;

	@Override
	public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
		return managerRepository.findById(id)
			.map(this::createUserDetail)
			.orElseThrow(() -> new UsernameNotFoundException("해당하는 관리자를 찾을 수 없습니다."));
	}

	private UserDetails createUserDetail(Manager manager) {
		return new User(Long.toString(manager.getNo()), manager.getPassword(), manager.getAuthorities());
	}
}
