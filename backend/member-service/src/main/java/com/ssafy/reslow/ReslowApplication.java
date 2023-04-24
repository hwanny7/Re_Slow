package com.ssafy.reslow;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;
// import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@EnableJpaAuditing
@EnableScheduling
@SpringBootApplication
// @EnableEurekaClient
public class ReslowApplication {

	public static void main(String[] args) {
		SpringApplication.run(ReslowApplication.class, args);
	}

}
