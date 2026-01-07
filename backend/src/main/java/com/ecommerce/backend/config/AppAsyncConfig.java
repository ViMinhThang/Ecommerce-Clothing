package com.ecommerce.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

@Configuration
@EnableAsync
public class AppAsyncConfig {
    @Bean(name = "taskExecutor") // Đặt tên Bean để gọi đích danh nếu cần
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);     // Luôn có 5 lính túc trực
        executor.setMaxPoolSize(10);     // Tối đa 10 lính nếu việc quá nhiều
        executor.setQueueCapacity(500);  // Hàng đợi chứa được 500 việc chưa kịp làm
        executor.setThreadNamePrefix("AI-Sync-"); // Đặt tên để dễ xem log (VD: AI-Sync-1)
        executor.initialize();
        return executor;
    }
}
