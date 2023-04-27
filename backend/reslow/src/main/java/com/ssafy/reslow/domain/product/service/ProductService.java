package com.ssafy.reslow.domain.product.service;

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
public class ProductService {

	private final RedisTemplate redisTemplate;

	public Map<String, Long> likeProduct(Long memberNo, Long productNo) {
		SetOperations<Object, Long> setOperations = redisTemplate.opsForSet();
		setOperations.add(productNo, memberNo);
		setOperations.add(memberNo + "_like_product", productNo);

		Map<String, Long> map = new HashMap<>();
		map.put("count", setOperations.size(productNo));
		return map;
	}

	public Map<String, Long> unlikeProduct(Long memberNo, Long productNo) {
		SetOperations<Object, Long> setOperations = redisTemplate.opsForSet();
		setOperations.remove(productNo, memberNo);
		setOperations.remove(memberNo + "_like_product", productNo);

		Map<String, Long> map = new HashMap<>();
		map.put("count", setOperations.size(productNo));
		return map;
	}
}
