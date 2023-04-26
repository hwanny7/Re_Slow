package com.ssafy.reslow.domain.knowhow.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
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
@Table(name = "KNOWHOW_COMMENT_TB")
@AttributeOverride(name = "no", column = @Column(name = "KNOWHOW_COMMENT_PK"))
public class KnowhowComment extends BaseEntity {

	@Column(name = "CONTENT", columnDefinition = "TEXT")
	private String content;

	@Column(name = "PARENT")
	private Long parentNo;
}
