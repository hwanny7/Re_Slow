package com.ssafy.reslow.batch.config;

import java.util.Collections;
import java.util.Map;

import javax.persistence.EntityManagerFactory;

import org.json.JSONObject;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.JobScope;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepScope;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.data.RepositoryItemReader;
import org.springframework.batch.item.data.builder.RepositoryItemReaderBuilder;
import org.springframework.batch.item.database.JpaItemWriter;
import org.springframework.batch.item.database.builder.JpaItemWriterBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.json.JSONObject;
import org.springframework.data.domain.Sort;

import com.ssafy.reslow.batch.entity.MemberAccount;
import com.ssafy.reslow.batch.entity.Order;
import com.ssafy.reslow.batch.entity.OrderStatus;
import com.ssafy.reslow.batch.entity.Settlement;
import com.ssafy.reslow.batch.infra.BankingService;
import com.ssafy.reslow.batch.repository.OrderRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
@RequiredArgsConstructor
public class SettlementBatchConfiguration {

	private final JobBuilderFactory jobBuilderFactory;
	private final StepBuilderFactory stepBuilderFactory;
	private final EntityManagerFactory entityManagerFactory;
	private final OrderRepository orderRepository;
	private final BankingService bankingService;

	private static final String SETTLEMENT_JOB_NAME = "settlementJob";
	private static final String SETTLEMENT_STEP1_NAME = "settlementStep1";

	public static final int CHUNK_SIZE = 10;


	@Bean
	public Job settlementJob(){
		return this.jobBuilderFactory.get(SETTLEMENT_JOB_NAME)
			.incrementer(new RunIdIncrementer())
			.start(settlementStep1())
			.build();
	}

	@JobScope
	@Bean
	public Step settlementStep1(){
		return this.stepBuilderFactory.get(SETTLEMENT_STEP1_NAME)
			.<Order, Settlement>chunk(CHUNK_SIZE)
			.reader(jpaPagingItemReader())
			.processor(itemProcessor())
			.writer(jpaItemWriter())
			.build();
	}

	@StepScope
	@Bean
	public RepositoryItemReader<Order> jpaPagingItemReader(){
		return new RepositoryItemReaderBuilder<Order>()
			.name("jpaPagingItemReader")
			.repository(orderRepository)
			.methodName("findByStatus")
			.pageSize(CHUNK_SIZE)
			.arguments(OrderStatus.ORDER_CONFIRMED)
			.sorts(Collections.singletonMap("no", Sort.Direction.ASC))
			.build();
	}

	@StepScope
	@Bean
	public ItemProcessor<Order, Settlement> itemProcessor(){
		return order -> {
			MemberAccount account = order.getProduct().getMember().getMemberAccount();

			//예금주 확인
			Map<String, Object> dpResponse = bankingService.inquireDepositorAccountNumber(
				account.getBank().getValue(),
				account.getAccountNumber()
			);
			JSONObject dpJson = new JSONObject(dpResponse);
			if(dpJson.getJSONObject("Header").get("Rpcd").equals("00000")){
				if(!dpJson.get("Dpnm").equals(account.getAccountHolder())){
					//예금주 일치하지 않을 시 예외처리
				}
			}
			else{
				//예금주 조회 실패 시 예외처리
				//조회할 수 없는 계좌
			}

			//입금이체
			Map<String, Object> rtResponse = bankingService.receivedTransferAccountNumber(
				account.getBank().getValue(),
				account.getAccountNumber(),
				String.valueOf(order.getTotalPrice()),
				account.getAccountHolder()
			);
			JSONObject rtJson = new JSONObject(rtResponse);
			if(!rtJson.getJSONObject("Header").get("Rpcd").equals("00000")){
				//이체 실패 시 예외처리
			}

			order.updateStatus(OrderStatus.SETTLEMENT_COMPLETED);
			return Settlement.of(order);
		};
	}

	@StepScope
	@Bean
	public JpaItemWriter<Settlement> jpaItemWriter(){
		return new JpaItemWriterBuilder<Settlement>()
			.entityManagerFactory(entityManagerFactory)
			.build();
	}

}
