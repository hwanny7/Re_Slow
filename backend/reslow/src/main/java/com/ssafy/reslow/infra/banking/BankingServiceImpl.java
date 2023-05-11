package com.ssafy.reslow.infra.banking;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class BankingServiceImpl implements BankingService {
	private final WebClient webClient =
		WebClient
			.builder()
			.baseUrl("https://developers.nonghyup.com/")
			.build();
	private final String NH_ACCESS_TOKEN = "b9de0b2eeedcadffeefdc7b311b64edb91fd37210209c3a48d4b2554d4a1b14b";
	private final String ISCD = "001862";
	private final String FINTECHAPSNO = "001";
	private final String APISVCCD = "DrawingTransferA";
	private final Map<String, Object> header = initHeader();
	private int cnt = 0;

	private Map<String, Object> initHeader() {
		Map<String, Object> headerMap = new HashMap<>();
		headerMap.put("Iscd", ISCD);
		headerMap.put("FintechApsno", FINTECHAPSNO);
		headerMap.put("ApiSvcCd", APISVCCD);
		headerMap.put("AccessToken", NH_ACCESS_TOKEN);

		return headerMap;
	}

	private void setTime() {
		header.put("Tsymd", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		header.put("Trtm", LocalDateTime.now().format(DateTimeFormatter.ofPattern("HHmmss")));
		header.put("IsTuno",
			String.format("%s%06d", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")), ++cnt));
	}

	@Override
	public Map<String, Object> receivedTransferAccountNumber(String bncd, String acno, String tram, String dractOtlt) {

		setTime();
		header.put("ApiNm", "ReceivedTransferAccountNumber");

		Map<String, Object> bodyMap = new HashMap<>();
		bodyMap.put("Header", header);
		bodyMap.put("Bncd", bncd);
		bodyMap.put("Acno", acno);
		bodyMap.put("Tram", tram);
		bodyMap.put("DractOtlt", dractOtlt);
		bodyMap.put("MractOtlt", "리슬로우");

		Map<String, Object> response = webClient
			.post()
			.uri("/ReceivedTransferAccountNumber.nh")
			.bodyValue(bodyMap)
			.retrieve()
			.bodyToMono(Map.class)
			.block();

		return response;
	}

	@Override
	public Map<String, Object> receivedTransferOtherBank(String bncd, String acno, String tram, String dractOtlt) {
		setTime();
		header.put("ApiNm", "ReceivedTransferOtherBank");

		Map<String, Object> bodyMap = new HashMap<>();
		bodyMap.put("Header", header);
		bodyMap.put("Bncd", bncd);
		bodyMap.put("Acno", acno);
		bodyMap.put("Tram", tram);
		bodyMap.put("DractOtlt", dractOtlt);
		bodyMap.put("MractOtlt", "리슬로우");

		Map<String, Object> response = webClient
			.post()
			.uri("/ReceivedTransferOtherBank.nh")
			.bodyValue(bodyMap)
			.retrieve()
			.bodyToMono(Map.class)
			.block();

		return response;
	}

	@Override
	public Map<String, Object> inquireDepositorAccountNumber(String bncd, String acno) {

		setTime();
		header.put("ApiNm", "InquireDepositorAccountNumber");

		Map<String, Object> bodyMap = new HashMap<>();
		bodyMap.put("Header", header);
		bodyMap.put("Bncd", bncd);
		bodyMap.put("Acno", acno);

		Map<String, Object> response = webClient
			.post()
			.uri("/InquireDepositorAccountNumber.nh")
			.bodyValue(bodyMap)
			.retrieve()
			.bodyToMono(Map.class)
			.block();

		return response;
	}

	@Override
	public Map<String, Object> inquireDepositorOtherBank(String bncd, String acno) {
		setTime();
		header.put("ApiNm", "InquireDepositorOtherBank");

		Map<String, Object> bodyMap = new HashMap<>();
		bodyMap.put("Header", header);
		bodyMap.put("Bncd", bncd);
		bodyMap.put("Acno", acno);

		Map<String, Object> response = webClient
			.post()
			.uri("/InquireDepositorOtherBank.nh")
			.bodyValue(bodyMap)
			.retrieve()
			.bodyToMono(Map.class)
			.block();

		return response;
	}

}
