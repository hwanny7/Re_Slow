package com.ssafy.reslow.global.config;

import org.springframework.boot.autoconfigure.data.redis.RedisProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.repository.configuration.EnableRedisRepositories;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Configuration
@EnableRedisRepositories
public class RedisRepositoryConfig {

	private final RedisProperties redisProperties;

	// lettuce
	@Bean
	public RedisConnectionFactory redisConnectionFactory() {
		LettuceConnectionFactory lettuceConnectionFactory = new LettuceConnectionFactory(
			redisProperties.getHost(), redisProperties.getPort());
		lettuceConnectionFactory.setPassword(redisProperties.getPassword());
		return lettuceConnectionFactory;
	}

	@Bean
	public RedisTemplate<String, Object> redisTemplate() {
		RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
		redisTemplate.setConnectionFactory(redisConnectionFactory());
		redisTemplate.setKeySerializer(new StringRedisSerializer());
		redisTemplate.setValueSerializer(new StringRedisSerializer());
		redisTemplate.setValueSerializer(new Jackson2JsonRedisSerializer<>(Object.class));

		return redisTemplate;
	}



}
