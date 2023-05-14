package com.ssafy.reslow.domain.member.entity;

import com.ssafy.reslow.domain.member.dto.MemberUpdateRequest;
import com.ssafy.reslow.global.common.entity.BaseEntity;
import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
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
@Table(name = "MEMBER_ADDRESS_TB")
@AttributeOverride(name = "no", column = @Column(name = "MEMBER_ADDRESS_PK"))
public class MemberAddress extends BaseEntity {

    @Column(name = "RECIPIENT")
    private String recipient;

    @Column(name = "ZIPCODE")
    private int zipCode;

    @Column(name = "ADDRESS")
    private String address;

    @Column(name = "ADDRESS_DETAIL")
    private String addressDetail;

    @Column(name = "PHONE_NUM")
    private String phoneNum;

    @Column(name = "MEMO")
    private String memo;

    public static MemberAddress toEntity(MemberUpdateRequest request) {
        return MemberAddress.builder()
            .recipient(request.getRecipient())
            .zipCode(request.getZipcode())
            .address(request.getAddress())
            .addressDetail(request.getAddressDetail())
            .phoneNum(request.getPhoneNumber())
            .memo(request.getMemo())
            .build();
    }

    public void update(MemberUpdateRequest request) {
        this.recipient = request.getRecipient();
        this.zipCode = request.getZipcode();
        this.address = request.getAddress();
        this.addressDetail = request.getAddressDetail();
        this.address = request.getAddress();
        this.phoneNum = request.getPhoneNumber();
        this.memo = request.getMemo();
    }
}