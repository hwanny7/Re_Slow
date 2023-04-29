package com.ssafy.reslow.domain.product.entity;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

import com.ssafy.reslow.domain.order.entity.OrderStatus;

@Converter
public class OrderStatusConverter implements AttributeConverter<OrderStatus, Integer> {

    @Override
    public Integer convertToDatabaseColumn(OrderStatus attribute) {
        return attribute.getValue();
    }

    @Override
    public OrderStatus convertToEntityAttribute(Integer dbData) {
        return OrderStatus.ofValue(dbData);
    }
}