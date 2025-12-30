package com.ecommerce.backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Get absolute path to uploads directory
        Path uploadPath = Paths.get("uploads").toAbsolutePath();
        String uploadLocation = "file:" + uploadPath.toString() + "/";

        System.out.println("Configuring static resource handler for /uploads/** -> " + uploadLocation);

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadLocation);
    }
}
