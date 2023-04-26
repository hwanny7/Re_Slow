package com.ssafy.reslow.global.auth.jwt;

import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import com.ssafy.reslow.domain.member.service.CustomMemberDetailService;

import lombok.Getter;
import lombok.Setter;

@Component
public class MemberProvider implements AuthenticationProvider {

	@Autowired
	CustomMemberDetailService userDetailsService;

	@SuppressWarnings("unchecked")
	@Override
	public Authentication authenticate(Authentication authentication)
		throws AuthenticationException {
		String userId = authentication.getName();
		String userPassword = authentication.getCredentials().toString();

		UserDetails user = userDetailsService.loadUserByUsername(userId);
		if (!user.isEnabled()) {
			throw new BadCredentialsException(user.getUsername());
		}
		return new UsernamePasswordAuthenticationToken(user.getUsername(), userPassword,
			user.getAuthorities());
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}

	public class UserToken extends UsernamePasswordAuthenticationToken {

		private static final long serialVersionUID = 1L;

		@Getter
		@Setter
		UserDetails user;

		public UserToken(Object principal, Object credentials,
			Collection<? extends GrantedAuthority> authorities, UserDetails user) {
			super(principal, credentials, user.getAuthorities());
			this.user = user;
		}

		@Override
		public Object getDetails() {
			return user;
		}
	}
}
