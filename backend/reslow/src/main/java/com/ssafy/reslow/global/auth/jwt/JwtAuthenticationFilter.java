package com.ssafy.reslow.global.auth.jwt;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.reslow.global.common.dto.ReissueResponse;

import io.jsonwebtoken.ExpiredJwtException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

	private static final String AUTHORIZATION_HEADER = "Authorization";
	private static final String BEARER_TYPE = "Bearer";

	private final JwtTokenProvider jwtTokenProvider;
	private final RedisTemplate redisTemplate;

	@Override
	public void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
		FilterChain chain) throws IOException, ServletException {
		try {
			String path = request.getServletPath();
			if (path.endsWith("reissue")) {
				chain.doFilter(request, response);
			} else {
				String accessToken = resolveToken(request);
				boolean isTokenValid = jwtTokenProvider.validateToken(accessToken);
				if (StringUtils.hasText(accessToken) && isTokenValid) {
					String isLogout = (String)redisTemplate.opsForValue().get(accessToken);
					if (ObjectUtils.isEmpty(isLogout)) {
						Authentication authentication = jwtTokenProvider.getAuthentication(
							accessToken);
						SecurityContextHolder.getContext().setAuthentication(authentication);
					}
				}
				chain.doFilter(request, response);
			}
		} catch (ExpiredJwtException e) {
			response.setStatus(HttpStatus.UNAUTHORIZED.value());
			response.setContentType("application/json;charset=UTF-8");
			response.getWriter().write(new ObjectMapper().writeValueAsString(ReissueResponse.reissue()));
			response.getWriter().flush();
		}
	}

	private String resolveToken(HttpServletRequest request) {
		String bearerToken = request.getHeader(AUTHORIZATION_HEADER);
		if (StringUtils.hasText(bearerToken) && bearerToken.startsWith(BEARER_TYPE)) {
			return bearerToken.substring(7);
		}
		return null;
	}
}
