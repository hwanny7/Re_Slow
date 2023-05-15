package com.ssafy.reslow.domain.order.dto;

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

    public static OrderComfirmationResponse of(Product product, Order order) {
        int totalPrice = product.getPrice() + product.getDeliveryFee();
        int discountPrice = 0;
        if (order.getIssuedCoupon() != null) {
            double discount = order.getIssuedCoupon().getCoupon().getDiscountPercent() * 0.01;
            discountPrice = (int) (totalPrice * discount);
            totalPrice -= discountPrice;
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
            .build();
    }
}
