package com.ssafy.reslow.domain.knowhow.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowRequest;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowUpdateRequest;
import com.ssafy.reslow.domain.member.entity.Member;
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
@Table(name = "KNOWHOW_TB")
@AttributeOverride(name = "no", column = @Column(name = "KNOWHOW_PK"))

public class Knowhow extends BaseEntity {

	@Column(name = "TITLE")
	private String title;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MEMBER_PK")
	private Member member;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "KNOWHOW_CATEGORY_PK")
	private KnowhowCategory knowhowCategory;

	@Builder.Default
	@OneToMany(mappedBy = "knowhow", cascade = CascadeType.ALL)
	private List<KnowhowContent> knowhowContents = new ArrayList<>();

	@Builder.Default
	@OneToMany(mappedBy = "knowhow", cascade = CascadeType.ALL)
	private List<KnowhowComment> knowhowComments = new ArrayList<>();

	public static Knowhow of(KnowhowRequest knowhowRequest, Member member, KnowhowCategory knowhowCategory) {
		return Knowhow.builder()
			.title(knowhowRequest.getTitle())
			.member(member)
			.knowhowCategory(knowhowCategory)
			.build();
	}

	public void update(KnowhowUpdateRequest knowhowRequest, Member member, KnowhowCategory knowhowCategory) {
		this.title = knowhowRequest.getTitle();
		this.member = member;
		this.knowhowCategory = knowhowCategory;
	}
}
