package com.ssafy.reslow.domain.member.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.ColumnDefault;

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
@Table(name = "DEVICE_TB")
@AttributeOverride(name = "no", column = @Column(name = "DEVICE_PK"))
public class Device extends BaseEntity {

	@Column(name = "DEVICE_TOKEN")
	private String deviceToken;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MEMBER_PK")
	private Member member;

	@Column(name = "NOTICE")
	@ColumnDefault("true")
	private boolean notice;

	public static Device of(Member member, String token) {
		return Device.builder().deviceToken(token).member(member).notice(true).build();
	}
}
