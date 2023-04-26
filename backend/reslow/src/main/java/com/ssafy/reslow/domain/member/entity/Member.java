package com.ssafy.reslow.domain.member.entity;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.ssafy.reslow.domain.market.entity.ProductIntro;
import com.ssafy.reslow.global.common.BaseEntity;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "MEMBER_TB")
@AttributeOverride(name = "no", column = @Column(name = "MEMBER_PK"))
public class Member extends BaseEntity implements UserDetails {

	@Column(name = "NICKNAME")
	private String nickname;

	@Column(name = "ID")
	private String id;

	@Column(name = "PASSWORD")
	private String password;

	@Column(name = "PROFILE_PIC")
	private String profilePic;

	@Column(name = "PHONE_NUM")
	private String phoneNum;

	@Column(name = "IS_CERTIFICATION")
	private boolean isCertification;
	@OneToOne
	@JoinColumn(name = "MEMBER_ACCOUNT_PK")
	private MemberAccount memberAccount;

	@OneToOne
	@JoinColumn(name = "MEMBER_ADDRESS_PK")
	private MemberAddress memberAddress;

	@Builder.Default
	@OneToMany(mappedBy = "member", cascade = CascadeType.ALL)
	private List<ProductIntro> productIntros = new ArrayList<>();

	@Builder.Default
	@OneToMany(mappedBy = "member", cascade = CascadeType.ALL)
	private List<Device> devices = new ArrayList<>();

	@Column
	@Builder.Default
	@ElementCollection(fetch = FetchType.EAGER)
	private List<String> roles = new ArrayList<>();

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return null;
	}

	@Override
	public String getUsername() {
		return null;
	}

	@Override
	public boolean isAccountNonExpired() {
		return false;
	}

	@Override
	public boolean isAccountNonLocked() {
		return false;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return false;
	}

	@Override
	public boolean isEnabled() {
		return false;
	}
}