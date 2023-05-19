package com.ssafy.reslow.batch.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
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
@Table(name = "MEMBER_TB")
@AttributeOverride(name = "no", column = @Column(name = "MEMBER_PK"))
public class Member extends BaseEntity {

	@Column(name = "IS_CERTIFICATION")
	private boolean isCertification;

	@OneToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "MEMBER_ACCOUNT_PK")
	private MemberAccount memberAccount;

	@Builder.Default
	@OneToMany(mappedBy = "member", cascade = CascadeType.ALL)
	private List<Product> products = new ArrayList<>();

}