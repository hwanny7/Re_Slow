package com.ssafy.reslow.infra.banking;

import java.util.Map;

public interface BankingService {
	Map<String, Object> receivedTransferAccountNumber(String bncd, String acno, String tram, String dractOtlt);

	Map<String, Object> receivedTransferOtherBank(String bncd, String acno, String tram, String dractOtlt);

	Map<String, Object> inquireDepositorAccountNumber(String bncd, String acno);

	Map<String, Object> inquireDepositorOtherBank(String bncd, String acno);

}
