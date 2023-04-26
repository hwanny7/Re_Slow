package com.ssafy.reslow.domain.knowhow.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
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
@Table(name = "KNOWHOW_CATEGORY_TB")
public class KnowhowCategory{

	@Id
	@GeneratedValue
	@Column(name = "KNOWHOW_CATEGORY_PK")
	private Long no;

	@Column(name = "KNOWHOW_CATEGORY")
	private String category;
	
}
