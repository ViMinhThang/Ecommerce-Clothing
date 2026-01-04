package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.AiResponse;
import com.ecommerce.backend.dto.view.ProductView;
import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.utils.MathUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Service
public class AiRecommentServiceImpl implements  AiRecommentService{
    private static final String URL_API = "https://votanthanh32004-recomment-system.hf.space";
    private static final int K_ITEM = 5;
    private final ProductService productService;
    private final ObjectMapper mapper;
    private final ConcurrentMap<Long, List<Long>> similarProductStore;
    private HttpClient client;

    public AiRecommentServiceImpl(ProductService productService, ObjectMapper mapper) {
        this.productService = productService;
        this.client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.mapper = new ObjectMapper();
        this.similarProductStore = new ConcurrentHashMap<>();
    }

    @Override
    public List<ProductView> getSimilarProducts(long productId) {
        var productIds = this.similarProductStore.getOrDefault(productId, new ArrayList<>());
        return this.productService.getByListId(productIds);
    }
    @Override
    public void buildCache() throws JsonProcessingException {
        var products = productService.getAll();
        String requestJson = createRequestBody(products);
        String response = getVectorsFromAI(requestJson);
        var vectors = mapVectorToProducts(response);
        Map<Long,List<Double>> tempVectorMap = new HashMap<>();
        if (vectors != null && vectors.size() == products.size()) {
            for (int i = 0; i < products.size(); i++) {
                long productId = products.get(i).getId(); // Lấy ID từ list gốc
                List<Double> vector = vectors.get(i);    // Lấy vector tương ứng
                tempVectorMap.put(productId, vector);    // Lưu vào Map tạm
            }
        }
        processAndCacheVectors(products,vectors);
    }
    private String getVectorsFromAI(String requestJson) {
        // gọi api
        String mainUrl = URL_API + "/vectorize"; // Nối thêm endpoint
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(mainUrl))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(requestJson))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 200) {
                return response.body(); // Trả về chuỗi JSON chứa vectors
            } else {
                return null;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    private String createRequestBody(List<ProductView> products){
        var productNames = products.stream().map(ProductView::getName).toList();
        return this.mapper.createObjectNode().putPOJO("products",productNames).toString();
    }
    private List<List<Double>> mapVectorToProducts(String response) throws JsonProcessingException {
        AiResponse aiResponse = this.mapper.readValue(response, AiResponse.class);
        return aiResponse.getVectors();
    }

    public void processAndCacheVectors(List<ProductView> products, List<List<Double>> vectors) {
        // 1. Validate dữ liệu
        if (products == null || vectors == null || products.size() != vectors.size()) {
            System.err.println("❌ Dữ liệu không khớp hoặc rỗng!");
            return;
        }

        int size = products.size();
        boolean useParallel = size > 1000;

        IntStream stream = IntStream.range(0, size);
        if(useParallel){
            stream = stream.parallel();
        }
        stream.forEach(i -> {
            // Lấy dữ liệu của sản phẩm gốc (Source)
            List<Double> sourceVector = vectors.get(i);
            Long sourceId = products.get(i).getId();

            // Map tạm để lưu điểm số của riêng sản phẩm này (Nhẹ hơn nhiều map to)
            // Key: ID sản phẩm khác, Value: Điểm tương đồng
            Map<Long, Double> scoreMap = new HashMap<>();

            // Vòng lặp so sánh với các sản phẩm còn lại
            for (int j = 0; j < size; j++) {
                if (i == j) continue; // Bỏ qua chính nó

                // Lấy dữ liệu sản phẩm đích (Target) trực tiếp từ index j
                // Không cần get từ Map, truy cập mảng cực nhanh O(1)
                List<Double> targetVector = vectors.get(j);

                // Tính toán
                double score = MathUtils.cosineSimilarity(sourceVector, targetVector);

                if (score > 0.5) { // Ngưỡng lọc
                    // Lấy ID trực tiếp từ list products tại vị trí j
                    scoreMap.put(products.get(j).getId(), score);
                }
            }

            // 3. Sắp xếp và lấy Top 5 ngay lập tức
            List<Long> topSimilarIds = scoreMap.entrySet().stream()
                    .sorted(Map.Entry.<Long, Double>comparingByValue().reversed())
                    .limit(K_ITEM)
                    .map(Map.Entry::getKey)
                    .collect(Collectors.toList());

            // 4. PUT THẲNG VÀO CACHE KẾT QUẢ (ConcurrencyMap)
            similarProductStore.put(sourceId, topSimilarIds);
        });
    }
}
