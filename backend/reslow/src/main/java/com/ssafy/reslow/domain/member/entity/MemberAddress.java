package com.ssafy.reslow.domain.member.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

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
@Table(name = "MEMBER_ADDRESS_TB")
@AttributeOverride(name = "no", column = @Column(name = "MEMBER_ADDRESS_PK"))
public class MemberAddress extends BaseEntity {

	@Column(name = "RECIPIENT")
	private String recipient;

	@Column(name = "ZIPCODE")
	private int zipCode;

	@Column(name = "ADDRESS")
	private String address;

	@Column(name = "ADDRESS_DETAIL")
	private String addressDetail;

	@Column(name = "PHONE_NUM")
	private String phoneNum;

	@Column(name = "MEMO")
	private String memo;
}