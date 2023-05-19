package com.ssafy.reslow.infra.delivery;

import com.amazonaws.services.kms.model.NotFoundException;
import java.util.Arrays;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum Courier {
    CJ대한통운("04"),
    우체국택배("01"),
    한진택배("05"),
    로젠택배("06"),
    대신택배("22"),
    경동택배("23"),
    합동택배("32"),
    CU편의점택배("46"),
    GSPostbox택배("24"),
    한의사랑택배("16"),
    천일택배("17"),
    건영택배("18"),
    농협택배("53");

    private final String value;

    public String value() {
        return value;
    }

    public static Courier ofValue(String value) {
        return Arrays.stream(Courier.values())
            .filter(v -> value.equals(v.getValue()))
            .findAny()
            .orElseThrow(
                () -> new NotFoundException(String.format("상태코드에 [%s]가 존재하지 않습니다.", value)));
    }
}