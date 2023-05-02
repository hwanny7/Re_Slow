package com.ssafy.reslow.domain.member.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

import com.ssafy.reslow.domain.member.dto.MemberAccountRequest;
import com.ssafy.reslow.global.common.entity.BaseEntity;

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

	@Column(name = "BANK")
	private String bank;

	@Column(name = "ACCOUNT_NUMBER")
	private String accountNumber;

	@Column(name = "ACCOUNT_HOLDER")
	private String accountHolder;

	public static MemberAccount of(MemberAccountRequest request) {
		return MemberAccount.builder()
			.accountHolder(request.getAccountHolder())
			.accountNumber(request.getAccountNumber())
			.bank(request.getBank())
			.build();
	}
}
