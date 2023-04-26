package com.ssafy.reslow.domain.market.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.springframework.data.annotation.CreatedDate;

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
@Table(name = "ORDER_TB")
public class Order {
	@Id
	@GeneratedValue
	@Column(name = "ORDER_PK")
	private Long no;

	@Column(name = "ORDER_DT", updatable = false)
	@CreatedDate
	private LocalDateTime orderDate;

	@Column(name = "ORDER_AMOUNT")
	private int amount;

	@Column(name = "ORDER_STATUS")
	private String status;

	@Column(name = "RECIPIENT")
	private String recipient;

	@Column(name = "ZIPCODE")
	private int zipcode;

	@Column(name = "ADDRESS")
	private String address;

	@Column(name = "ADDRESS_DETAIL")
	private String addressDetail;

	@Column(name = "PHONE_NUM")
	private String phoneNumber;

	@Column(name = "MEMO")
	private String memo;

	@Column(name = "CARRIER_COMPANY")
	private String company;

	@Column(name = "CARRIER_TRACK")
	private int carrierTrack;

	@Builder.Default
	@OneToMany(mappedBy = "order")
	private List<Product> products = new ArrayList<>();
}
