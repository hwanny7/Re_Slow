package com.ssafy.reslow.domain.manager.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.ssafy.reslow.domain.manager.dto.ManagerLoginRequest;
import com.ssafy.reslow.domain.manager.dto.ManagerSignUpRequest;
import com.ssafy.reslow.domain.manager.entity.Manager;
import com.ssafy.reslow.domain.manager.repository.ManagerRepository;
import com.ssafy.reslow.global.auth.jwt.JwtTokenProvider;
import com.ssafy.reslow.global.common.dto.TokenResponse;
import com.ssafy.reslow.global.exception.CustomException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ManagerService {

	private final ManagerRepository managerRepository;
	private final PasswordEncoder passwordEncoder;
	private final JwtTokenProvider jwtTokenProvider;
	private final RedisTemplate redisTemplate;
	private final AuthenticationManager authenticationManager;

	public Map<String, Object> signUp(ManagerSignUpRequest signUp) {
		if (managerRepository.existsById(signUp.getId())) {
			throw new CustomException(MEBER_ALREADY_EXSIST);
		}
		Manager manager = managerRepository.save(
			Manager.toEntity(signUp, passwordEncoder.encode(signUp.getPassword())));
		Map<String, Object> map = new HashMap<>();
		map.put("no", manager.getId());
		return map;
	}

	public TokenResponse login(ManagerLoginRequest login) {
		Manager manager = managerRepository.findById(login.getId())
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		if (!passwordEncoder.matches(login.getPassword(), manager.getPassword())) {
			throw new CustomException(PASSWORD_NOT_MATCH);
		}

		UsernamePasswordAuthenticationToken authenticationToken = login.toAuthentication();
		Authentication authentication = authenticationManager.authenticate(authenticationToken);
		SecurityContextHolder.getContext().setAuthentication(authentication);
		TokenResponse tokenInfo = jwtTokenProvider.generateToken(authentication);

		redisTemplate.opsForValue()
			.set("RT_MANAGER:" + authentication.getName(), tokenInfo.getRefreshToken(),
				tokenInfo.getRefreshTokenExpirationTime(), TimeUnit.MILLISECONDS);
		return tokenInfo;
	}

	public Map<String, Object> logout(Authentication authentication) {
		if (redisTemplate.opsForValue().get("RT_MANAGER:" + authentication.getName()) != null) {
			redisTemplate.delete("RT_MANAGER:" + authentication.getName());
		}
		Map<String, Object> map = new HashMap<>();
		map.put("no", authentication.getName());
		return map;
	}
}
