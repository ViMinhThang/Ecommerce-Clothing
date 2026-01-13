package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.AiResponse;
import com.ecommerce.backend.model.Product;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

@Service
public class AiConnector {
    private static final String URL_API = "https://votanthanh32004-recomment-system.hf.space";
//    private static final String URL_API = "https://undeluged-marilyn-trappy.ngrok-free.dev";

    private final ObjectMapper mapper;
    private final HttpClient client;
    public AiConnector(ObjectMapper mapper){
        this.client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .build();
        this.mapper = mapper;
    }
    @Async("taskExecutor")
    public CompletableFuture<Map<Long, List<Long>>> addNewProductToPython(Product product) {
        String mainUrl = URL_API + "/add_product"; // Nối thêm endpoint
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(mainUrl))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(product.toBodyForPython()))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 200) {
                return CompletableFuture.completedFuture(convertResponse(response.body()));
            }else{
                return CompletableFuture.completedFuture(Collections.emptyMap());
            }
        } catch (Exception e) {
            e.printStackTrace();
            return CompletableFuture.failedFuture(e);
        }
    }

    // Chuyển đổi response về đối tượng cần dùng
    private Map<Long, List<Long>> convertResponse(String response) throws JsonProcessingException {
        AiResponse aiResponse = this.mapper.readValue(response, AiResponse.class);
        return aiResponse.getResult();
    }
    @Async("taskExecutor")
    public CompletableFuture<Integer> getStatus(){
        // gọi api lấy về số lượng item trong danh sách sản phẩm tương tự được tính toán trong Python
        String mainUrl = URL_API + "/status"; // Nối thêm endpoint
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(mainUrl))
                    .header("Content-Type", "application/json")
                    .GET()
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 200) {
                JsonNode rootNode = this.mapper.readTree(response.body());
                int count = rootNode.path("count").asInt(0);
                return CompletableFuture.completedFuture(count);
            } else {
                return CompletableFuture.completedFuture(0);
            }
        } catch (Exception e) {
            return CompletableFuture.failedFuture(e);
        }
    }
    @Async("taskExecutor")
    public CompletableFuture<Map<Long, List<Long>>> initDataToPython(String requestJson){
        String mainUrl = URL_API + "/vectorize"; // Nối thêm endpoint
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(mainUrl))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(requestJson))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 200) {
                return CompletableFuture.completedFuture(convertResponse(response.body())); // Trả về chuỗi JSON chứa kết quả
            }else{
                return CompletableFuture.completedFuture(Collections.emptyMap());
            }
        } catch (Exception e) {
            return CompletableFuture.failedFuture(e);
        }
    }

    @Async("taskExecutor")
    public CompletableFuture<Map<Long, List<Long>>> refreshCache(){
        String mainUrl = URL_API + "/refresh_cache"; // Nối thêm endpoint
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(mainUrl))
                    .header("Content-Type", "application/json")
                    .GET()
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 200) {
                return CompletableFuture.completedFuture(convertResponse(response.body()));
            }else{
                return CompletableFuture.completedFuture(Collections.emptyMap());
            }
        } catch (Exception e) {
            return CompletableFuture.failedFuture(e);
        }
    }
}
