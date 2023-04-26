package com.ssafy.reslow.domain.member.service;

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

import com.ssafy.reslow.domain.member.dto.MemberIdRequest;
import com.ssafy.reslow.domain.member.dto.MemberLoginRequest;
import com.ssafy.reslow.domain.member.dto.MemberSignUpRequest;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.global.auth.jwt.JwtTokenProvider;
import com.ssafy.reslow.global.common.dto.TokenResponse;
import com.ssafy.reslow.global.exception.CustomException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class MemberService {

	private final MemberRepository memberRepository;
	private final PasswordEncoder passwordEncoder;
	private final JwtTokenProvider jwtTokenProvider;
	private final RedisTemplate redisTemplate;
	private final AuthenticationManager authenticationManager;

	public Map<String, Object> signUp(MemberSignUpRequest signUp) {
		if (memberRepository.existsById(signUp.getId())) {
			throw new CustomException(MEBER_ALREADY_EXSIST);
		}
		Member member = memberRepository.save(Member.toEntity(signUp, passwordEncoder.encode(signUp.getPassword())));
		Map<String, Object> map = new HashMap<>();
		map.put("nickname", member.getNickname());
		return map;
	}

	public TokenResponse login(MemberLoginRequest login) {
		Member member = memberRepository.findById(login.getId())
			.orElseThrow(() -> new CustomException(USER_NOT_FOUND));
		if (!passwordEncoder.matches(login.getPassword(), member.getPassword())) {
			throw new CustomException(PASSWORD_NOT_MATCH);
		}

		UsernamePasswordAuthenticationToken authenticationToken = login.toAuthentication();
		Authentication authentication = authenticationManager.authenticate(authenticationToken);
		SecurityContextHolder.getContext().setAuthentication(authentication);
		TokenResponse tokenInfo = jwtTokenProvider.generateToken(authentication);

		redisTemplate.opsForValue()
			.set("RT:" + authentication.getName(), tokenInfo.getRefreshToken(),
				tokenInfo.getRefreshTokenExpirationTime(), TimeUnit.MILLISECONDS);
		return tokenInfo;
	}

	public Map<String, Object> logout(Authentication authentication) {
		if (redisTemplate.opsForValue().get("RT:" + authentication.getName()) != null) {
			redisTemplate.delete("RT:" + authentication.getName());
		}
		Map<String, Object> map = new HashMap<>();
		map.put("nickname", authentication.getName());
		return map;
	}

	public Map<String, Object> idDuplicate(MemberIdRequest id) {
		Map<String, Object> map = new HashMap<>();
		if (memberRepository.existsById(id.getId())) {
			map.put("isDuplicated", "YES");
		} else {
			map.put("isDuplicated", "NO");
		}
		return map;
	}

}
