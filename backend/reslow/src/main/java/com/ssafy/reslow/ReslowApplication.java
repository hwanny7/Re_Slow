package com.ssafy.reslow;

import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableJpaAuditing
@EnableScheduling
@EnableBatchProcessing
@SpringBootApplication(exclude = SecurityAutoConfiguration.class)
public class ReslowApplication {

    public static void main(String[] args) {
        SpringApplication.run(ReslowApplication.class, args);
    }

}
