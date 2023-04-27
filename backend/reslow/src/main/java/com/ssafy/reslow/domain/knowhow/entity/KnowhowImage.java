package com.ssafy.reslow.domain.knowhow.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
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
@Table(name = "KNOWHOW_IMAGE_TB")
public class KnowhowImage {

	@Id
	@GeneratedValue
	@Column(name = "KNOWHOW_IMAGE_PK")
	private Long no;

	@Column(name = "IMAGE_URL")
	private String url;


	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "KNOWHOW_PK")
	private Knowhow knowhow;
}
