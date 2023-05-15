package com.ssafy.reslow.batch.entity;

import java.util.Arrays;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum OrderStatus {
    COMPLETE_PAYMENT(1),
    PREPARE_DELIVERY(2),
    PROGRESS_DELIVERY(3),
    COMPLETE_DELIVERY(4),
    ORDER_CONFIRMED(5),
    ORDER_CANCELED(6);

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