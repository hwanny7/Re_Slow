package com.ssafy.reslow.batch.infra;

import java.util.Map;

public interface BankingService {
	Map<String, Object> receivedTransferAccountNumber(String bncd, String acno, String tram, String dractOtlt);

	Map<String, Object> inquireDepositorAccountNumber(String bncd, String acno);

}
