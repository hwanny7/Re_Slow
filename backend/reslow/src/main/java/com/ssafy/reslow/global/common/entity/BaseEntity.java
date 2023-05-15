package com.ssafy.reslow.global.common.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.EntityListeners;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@MappedSuperclass
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {

	@Id
	@GeneratedValue
	private Long no;

	@Column(name = "CREATED_DT", updatable = false)
	@CreatedDate
	@DateTimeFormat(pattern = "yyyy-DD-mm HH:mm:ss")
	private LocalDateTime createdDate;
	@Column(name = "UPDATED_DT")
	@LastModifiedDate
	@DateTimeFormat(pattern = "yyyy-DD-mm HH:mm:ss")
	private LocalDateTime updatedDate;

}
