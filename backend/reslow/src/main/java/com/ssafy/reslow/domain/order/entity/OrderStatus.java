package com.ssafy.reslow.domain.order.entity;

import com.amazonaws.services.kms.model.NotFoundException;
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
    ORDER_CANCEL(6);

    private final int value;

    public int value() {
        return value;
    }

    public static OrderStatus ofValue(int value) {
        return Arrays.stream(OrderStatus.values())
            .filter(v -> v.getValue() == value)
            .findAny()
            .orElseThrow(
                () -> new NotFoundException(String.format("상태코드에 [%s]가 존재하지 않습니다.", value)));
    }
}