package com.ecommerce.backend;

import jakarta.persistence.EntityListeners;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EntityListeners(AuditingEntityListener.class)
@EnableJpaAuditing
@EnableJpaRepositories
@EntityScan
public class BackendApplication {

	public static void main(String[] args) {
        System.setProperty("user.timezone", "Asia/Ho_Chi_Minh");

        SpringApplication.run(BackendApplication.class, args);
	}

}
