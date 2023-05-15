package com.ssafy.reslow.batch.entity;

import javax.persistence.AttributeOverride;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "ORDER_TB")
@AttributeOverride(name = "no", column = @Column(name = "ORDER_PK"))
public class Order extends BaseEntity {

    @Column(name = "ORDER_STATUS")
    @Convert(converter = OrderStatusConverter.class)
    private OrderStatus status;

    @Column(name = "RECIPIENT")
    private String recipient;

    @ColumnDefault("0")
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
    private String carrierCompany;

    @Column(name = "CARRIER_TRACK")
    private String carrierTrack;

    @ColumnDefault("0")
    @Column(name = "TOTAL_PRICE")
    private Long totalPrice;

    @OneToOne(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private Product product;

    @OneToOne(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private Settlement settlement;

    public void updateStatus(OrderStatus status) {
        this.status = status;
    }
}
