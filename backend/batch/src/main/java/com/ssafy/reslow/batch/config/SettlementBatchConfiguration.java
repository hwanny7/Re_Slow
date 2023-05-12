package com.ssafy.reslow.batch.config;

import javax.persistence.EntityManagerFactory;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.database.JpaCursorItemReader;
import org.springframework.batch.item.database.JpaItemWriter;
import org.springframework.batch.item.database.JpaPagingItemReader;
import org.springframework.batch.item.database.builder.JpaItemWriterBuilder;
import org.springframework.batch.item.database.builder.JpaPagingItemReaderBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.ssafy.reslow.batch.entity.Order;
import com.ssafy.reslow.batch.entity.Settlement;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
@RequiredArgsConstructor
public class SettlementBatchConfiguration {

	private final JobBuilderFactory jobBuilderFactory;
	private final StepBuilderFactory stepBuilderFactory;
	private final EntityManagerFactory entityManagerFactory;

	private static final String SETTLEMENT_JOB_NAME = "settlementJob";
	private static final String SETTLEMENT_STEP1_NAME = "settlementStep1";

	public static final int CHUNK_SIZE = 1;


	@Bean
	public Job settlementJob(){
		return this.jobBuilderFactory.get(SETTLEMENT_JOB_NAME)
			.incrementer(new RunIdIncrementer())
			.start(settlementStep1())
			.build();
	}

	@Bean
	public Step settlementStep1(){
		return this.stepBuilderFactory.get(SETTLEMENT_STEP1_NAME)
			.<Order, Settlement>chunk(CHUNK_SIZE)
			.reader(jpaPagingItemReader())
			.processor(itemProcessor())
			.writer(jpaItemWriter())
			.build();
	}

	@Bean
	public JpaPagingItemReader<Order> jpaPagingItemReader(){
		return new JpaPagingItemReaderBuilder<Order>()
			.name("jpaPagingItemReader")
			.entityManagerFactory(entityManagerFactory)
			.pageSize(CHUNK_SIZE)
			.queryString("SELECT o FROM Order o WHERE status = 5")
			.build();
	}

	@Bean
	public ItemProcessor<Order, Settlement> itemProcessor(){
		return order -> Settlement.of(order);
	}

	@Bean
	public JpaItemWriter<Settlement> jpaItemWriter(){
		return new JpaItemWriterBuilder<Settlement>()
			.entityManagerFactory(entityManagerFactory)
			.build();
	}

}
