package com.ssafy.reslow.global.config;

import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import com.ssafy.reslow.domain.order.repository.OrderRepository;
import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
@RequiredArgsConstructor
@EnableBatchProcessing
public class BatchConfig {

    final public JobBuilderFactory jobBuilderFactory;
    final public StepBuilderFactory stepBuilderFactory;
    final private OrderRepository orderRepository;

    @Bean
    public Job job() {

        Job job = jobBuilderFactory.get("job")
            .start(step())
            .build();

        return job;
    }

    @Bean
    public Step step() {
        return stepBuilderFactory.get("step")
            .tasklet((contribution, chunkContext) -> {
                LocalDateTime now = LocalDateTime.now();
                LocalDateTime daysAgo = now.minusDays(3);
                List<Order> list = orderRepository.findByUpdatedDateLessThanAndStatus(daysAgo,
                    OrderStatus.COMPLETE_DELIVERY);
                list.stream().forEach(order -> {
                    order.updateStatus(OrderStatus.COMPLETE_TRANSACTION);
                    orderRepository.save(order);
                });
                return RepeatStatus.FINISHED;
            })
            .build();
    }
}