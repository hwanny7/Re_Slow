package com.ssafy.reslow.batch.config;

import com.ssafy.reslow.batch.entity.Order;
import com.ssafy.reslow.batch.entity.OrderStatus;
import com.ssafy.reslow.batch.infra.DeliveryService;
import com.ssafy.reslow.batch.repository.OrderRepository;
import java.time.LocalDateTime;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONObject;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepScope;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemWriter;
import org.springframework.batch.item.data.RepositoryItemReader;
import org.springframework.batch.item.data.builder.RepositoryItemReaderBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.Sort;

@Slf4j
@Configuration
@RequiredArgsConstructor
@EnableBatchProcessing
public class DeliveryBatchConfiguration {

    final public JobBuilderFactory jobBuilderFactory;
    final public StepBuilderFactory stepBuilderFactory;
    final private OrderRepository orderRepository;
    private final DeliveryService deliveryService;

    private static final int CHUNK_SIZE = 10;

    @Bean
    public Job deliveryConfirmJob() {

        Job job = jobBuilderFactory.get("deliveryConfirmJob")
            .start(deliveryConfirmStep())
            .build();

        return job;
    }

    @Bean
    public Step deliveryConfirmStep() {
        return stepBuilderFactory.get("deliveryConfirmStep")
            .<Order, Order>chunk(CHUNK_SIZE)
            .reader(orderItemReader())
            .processor(orderItemProcessor())
            .writer(orderItemWriter())
            .build();
    }

    @StepScope
    @Bean
    public RepositoryItemReader<Order> orderItemReader() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime daysAgo = now.minusDays(3);

        return new RepositoryItemReaderBuilder<Order>()
            .name("orderItemReader")
            .repository(orderRepository)
            .methodName("findByUpdatedDateLessThanAndStatus")
            .pageSize(CHUNK_SIZE)
            .arguments(daysAgo, OrderStatus.DELIVERY_COMPLETE)
            .sorts(Collections.singletonMap("no", Sort.Direction.ASC))
            .build();
    }

    @StepScope
    @Bean
    public ItemProcessor<Order, Order> orderItemProcessor() {
        return orderItem -> orderItem;
    }

    @StepScope
    @Bean
    public ItemWriter<Order> orderItemWriter() {
        return order -> order.forEach(orderItem -> {
            orderItem.updateStatus(OrderStatus.ORDER_CONFIRMED);
            orderRepository.save(orderItem);
        });
    }

    @Bean
    public Job deliveryTrackJob() {

        Job job = jobBuilderFactory.get("deliveryTrackJob")
            .start(deliveryTrackStep())
            .build();

        return job;
    }

    @Bean
    public Step deliveryTrackStep() {
        return stepBuilderFactory.get("deliveryTrackStep")
            .<Order, Order>chunk(CHUNK_SIZE)
            .reader(trackItemReader())
            .processor(trackItemProcessor())
            .writer(trackItemWriter())
            .build();
    }

    @StepScope
    @Bean
    public RepositoryItemReader<Order> trackItemReader() {
        return new RepositoryItemReaderBuilder<Order>()
            .name("trackItemReader")
            .repository(orderRepository)
            .methodName("findByStatus")
            .pageSize(CHUNK_SIZE)
            .arguments(OrderStatus.DELIVERY_PROGRESS)
            .sorts(Collections.singletonMap("no", Sort.Direction.ASC))
            .build();
    }

    @StepScope
    @Bean
    public ItemProcessor<Order, Order> trackItemProcessor() {
        return orderItem -> orderItem;
    }

    @StepScope
    @Bean
    public ItemWriter<Order> trackItemWriter() {
        return orderItem -> orderItem.forEach(order -> {
            String carrierCompany = order.getCarrierCompany();
            String carrierTrack = order.getCarrierTrack();
            String response = deliveryService.directDeliveryTracking(carrierCompany,
                carrierTrack);
            JSONObject jsonObject = new JSONObject(response);
            if (jsonObject.get("completeYN").equals("Y")) {
                order.updateStatus(OrderStatus.DELIVERY_COMPLETE);
            }
        });
    }
}