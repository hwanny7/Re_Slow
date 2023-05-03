package com.ssafy.reslow.global.auth.config;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AnonymousAuthenticationFilter;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsUtils;

import com.ssafy.reslow.domain.manager.service.CustomManagerDetailService;
import com.ssafy.reslow.domain.member.service.CustomMemberDetailService;
import com.ssafy.reslow.global.auth.handler.JwtAccessDeniedHandler;
import com.ssafy.reslow.global.auth.jwt.JwtAuthenticationEntryPoint;
import com.ssafy.reslow.global.auth.jwt.JwtAuthenticationFilter;
import com.ssafy.reslow.global.auth.jwt.JwtTokenProvider;
import com.ssafy.reslow.global.auth.jwt.ManagerProvider;
import com.ssafy.reslow.global.auth.jwt.MemberProvider;
import com.ssafy.reslow.global.common.dto.CustomUser;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

	private final JwtTokenProvider jwtTokenProvider;
	private final RedisTemplate redisTemplate;
	private final CustomMemberDetailService customMemberDetailService;
	private final MemberProvider memberProvider;
	private final CustomManagerDetailService customManagerDetailService;
	private final ManagerProvider managerProvider;
	private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

	private final JwtAccessDeniedHandler jwtAccessDeniedHandler;

	@Override
	protected void configure(HttpSecurity httpSecurity) throws Exception {
		httpSecurity
			.httpBasic().disable()
			.formLogin().disable()
			.csrf().disable();
		httpSecurity.anonymous().authenticationFilter(customAnonymousFilter());
		httpSecurity.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);
		httpSecurity
			.authorizeRequests()
			.requestMatchers(CorsUtils::isPreFlightRequest).permitAll()
			.antMatchers("/products/sale", "/orders/purchase").hasRole("USER")
			.antMatchers("/**", "/members/**", "/managers/**", "/coupons/**", "/notices/**","/orders/**",
				"/knowhows/**", "/chattings/**", "/likes/**", "/products/**").permitAll()
			.and()
			.addFilterBefore(new JwtAuthenticationFilter(jwtTokenProvider, redisTemplate),
				UsernamePasswordAuthenticationFilter.class);
		httpSecurity.exceptionHandling()
			.accessDeniedHandler(jwtAccessDeniedHandler)
			.authenticationEntryPoint(jwtAuthenticationEntryPoint);
	}

	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.authenticationProvider(memberProvider);
		auth.userDetailsService(customMemberDetailService).passwordEncoder(passwordEncoder());
		auth.authenticationProvider(managerProvider);
		auth.userDetailsService(customManagerDetailService).passwordEncoder(passwordEncoder());
	}

	protected CustomAnonymousFilter customAnonymousFilter() throws Exception {
		return new CustomAnonymousFilter();
	}

	public static class CustomAnonymousFilter extends AnonymousAuthenticationFilter {
		private final Logger log = LoggerFactory.getLogger(getClass());

		public CustomAnonymousFilter() {
			super("ANONYMOUS_FILTER");
		}

		@Override
		public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {

			if (SecurityContextHolder.getContext().getAuthentication() == null) {
				Authentication authentication = createAuthentication((HttpServletRequest)req);
				SecurityContextHolder.getContext().setAuthentication(authentication);
				if (log.isDebugEnabled()) {
					log.debug("Anonymous user:{}", SecurityContextHolder.getContext().getAuthentication());
				}
			}
			chain.doFilter(req, res);
		}

		@Override
		protected Authentication createAuthentication(HttpServletRequest request) {
			List<? extends GrantedAuthority> authorities = Collections
				.unmodifiableList(Arrays.asList(new SimpleGrantedAuthority("ANONYMOUS_USER")));
			CustomUser principal = new CustomUser("253243", authorities); // 비회원 UID
			return new AnonymousAuthenticationToken("ANONYMOUS", principal, authorities);
		}
	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	@Override
	public AuthenticationManager authenticationManagerBean() throws Exception {
		return super.authenticationManagerBean();
	}
}
