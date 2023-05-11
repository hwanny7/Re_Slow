package com.ssafy.reslow.global.config;

import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import com.ssafy.reslow.domain.order.repository.OrderRepository;
import com.ssafy.reslow.infra.delivery.DeliveryService;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
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
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;

@Slf4j
@Configuration
@RequiredArgsConstructor
@EnableBatchProcessing
public class BatchConfig {

    final public JobBuilderFactory jobBuilderFactory;
    final public StepBuilderFactory stepBuilderFactory;
    final private OrderRepository orderRepository;
    private final RedisTemplate redisTemplate;
    private final DeliveryService deliveryService;

    @Bean
    public Job deliveryConfirmJob() {

        Job job = jobBuilderFactory.get("deliveryConfirmJob")
            .start(deliveryConfirmStep())
            .build();

        return job;
    }

    @Bean
    public Job deliveryTrackJob() {

        Job job = jobBuilderFactory.get("deliveryTrackJob")
            .start(deliveryTrackStep())
            .build();

        return job;
    }

    @Bean
    public Step deliveryConfirmStep() {
        return stepBuilderFactory.get("deliveryConfirmStep")
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

    @Bean
    public Step deliveryTrackStep() {
        return stepBuilderFactory.get("deliveryTrackStep")
            .tasklet((contribution, chunkContext) -> {
                SetOperations<String, String> setOperations = redisTemplate.opsForSet();
                // 배송중인 친구들만 조회하기
                List<Order> list = orderRepository.findByStatus(OrderStatus.PROGRESS_DELIVERY);
                // 운송장 조회
                list.stream().forEach(order -> {
                    String carrierCompany = order.getCarrierCompany();
                    String carrierTrack = order.getCarrierTrack();
                    Map<String, Object> response = deliveryService.deliveryTracking(carrierCompany, carrierTrack);
                    if(response.get("completeYN").equals("Y")){
                        log.info("=================== 배송완료 된 것 ===================");
                        order.updateStatus(OrderStatus.COMPLETE_DELIVERY);
                    }
                    setOperations.add(carrierCompany+"_"+carrierTrack, String.valueOf(response));
                });
                
                return RepeatStatus.FINISHED;
            })
            .build();
    }
}