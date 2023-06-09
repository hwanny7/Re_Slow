package com.ssafy.reslow.domain.order.dto;

import com.ssafy.reslow.domain.coupon.entity.Coupon;
import com.ssafy.reslow.domain.coupon.entity.IssuedCoupon;
import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.product.entity.Product;
import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class OrderComfirmationResponse {

    private String title;
    private LocalDateTime date;
    private String recipient;
    private int zipcode;
    private String address;
    private String addressDetail;
    private String phoneNumber;
    private String memo;
    private String image;
    private int totalPrice;
    private int productPrice;
    private int discountPrice;
    private int deliveryFee;
    private String carrierTrack;
    private String carrierCompany;

    public static OrderComfirmationResponse of(Product product, Order order) {
        IssuedCoupon issuedCoupon = order.getIssuedCoupon();
        int totalPrice = product.getPrice() + product.getDeliveryFee();
        int discountPrice = 0;
        if (issuedCoupon != null) {
            Coupon coupon = issuedCoupon.getCoupon();
            if(coupon.getDiscountType() == 1) { // 금액
                discountPrice = (product.getPrice()<=coupon.getDiscountAmount())?product.getPrice():product.getPrice()-coupon.getDiscountAmount();
            } else {
                double discount = issuedCoupon.getCoupon().getDiscountPercent() * 0.01;
                discountPrice = (int) (totalPrice * discount);
                totalPrice -= discountPrice;
            }
        }
        return OrderComfirmationResponse.builder()
            .title(product.getTitle())
            .image(product.getProductImages().isEmpty() ? null
                : product.getProductImages().get(0).getUrl())
            .totalPrice(totalPrice)
            .productPrice(product.getPrice())
            .discountPrice(discountPrice)
            .deliveryFee(product.getDeliveryFee())
            .date(order.getCreatedDate())
            .recipient(order.getRecipient())
            .zipcode(order.getZipcode())
            .address(order.getAddress())
            .addressDetail(order.getAddressDetail())
            .phoneNumber(order.getPhoneNumber())
            .memo(order.getMemo())
            .carrierTrack(order.getCarrierTrack())
            .carrierCompany(order.getCarrierCompany())
            .build();
    }
}
