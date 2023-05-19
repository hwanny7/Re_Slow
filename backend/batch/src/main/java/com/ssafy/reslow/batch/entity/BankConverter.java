package com.ssafy.reslow.batch.entity;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter
public class BankConverter implements AttributeConverter<Bank, String> {

	@Override
	public String convertToDatabaseColumn(Bank attribute) {
		return attribute.getValue();
	}

	@Override
	public Bank convertToEntityAttribute(String dbData) {
		return Bank.ofValue(dbData);
	}
}