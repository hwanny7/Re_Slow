package com.ssafy.reslow.batch.entity;

import java.util.Arrays;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum OrderStatus {
    PAYMENT_COMPLETE(1),
    DELIVERY_PREPARE(2),
    DELIVERY_PROGRESS(3),
    DELIVERY_COMPLETE(4),
    ORDER_CONFIRMED(5),
    ORDER_CANCELED(6),
    SETTLEMENT_COMPLETED(7);

    private final int value;

    public static OrderStatus ofValue(int value) {
        return Arrays.stream(OrderStatus.values())
            .filter(v -> v.getValue() == value)
            .findAny()
            .orElseThrow(
                () -> new RuntimeException(String.format("상태코드에 [%s]가 존재하지 않습니다.", value)));
    }

    public int value() {
        return value;
    }
}