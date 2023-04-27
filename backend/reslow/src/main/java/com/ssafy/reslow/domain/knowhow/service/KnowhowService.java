package com.ssafy.reslow.domain.knowhow.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class KnowhowService {

	private final RedisTemplate redisTemplate;

	public Map<String, Long> likeKnowhow(Long memberNo, Long knowhowNo) {
		SetOperations<Object, Long> setOperations = redisTemplate.opsForSet();
		setOperations.add(knowhowNo, memberNo);
		setOperations.add(memberNo + "_like_knowhow", knowhowNo);

		Map<String, Long> map = new HashMap<>();
		map.put("count", setOperations.size(knowhowNo));
		return map;
	}

	public Map<String, Long> unlikeKnowhow(Long memberNo, Long knowhowNo) {
		SetOperations<Object, Long> setOperations = redisTemplate.opsForSet();
		setOperations.remove(knowhowNo, memberNo);
		setOperations.remove(memberNo + "_like_knowhow", knowhowNo);

		Map<String, Long> map = new HashMap<>();
		map.put("count", setOperations.size(knowhowNo));
		return map;
	}
}
