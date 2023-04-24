package com.ssafy.reslow.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

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
@Table(name = "MEMBER_ACCOUNT_TB")
@AttributeOverride(name = "no", column = @Column(name = "MEMBER_ACCOUNT_PK"))
public class MemberAccount extends BaseEntity {

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
	private String isCertification;
}