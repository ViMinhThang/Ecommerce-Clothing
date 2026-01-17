package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.ProductAiDTO;
import com.ecommerce.backend.dto.view.ProductView;
import com.ecommerce.backend.model.Product;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Service
@RequiredArgsConstructor
public class AiRecommentServiceImpl implements  AiRecommentService{

    private final ProductService productService;
    private final ConcurrentMap<Long, List<Long>> similarProductStore = new ConcurrentHashMap<>();
    private final AiConnector aiConnector;
    private final ObjectMapper mapper;
    private static final int K_ITEM = 5;

    @Override
    public List<ProductView> getSimilarProducts(long productId) {
        var productIds = this.similarProductStore.getOrDefault(productId, new ArrayList<>());
        return this.productService.getByListId(productIds);
    }
    @Override
    public void buildCache() {
        try {
            var status = aiConnector.getStatus().join();
            // Nếu sản phẩm tương tự cùng rỗng ở Java và Python thì truy vấn và khởi tạo
            if(this.similarProductStore.isEmpty() && status == 0){
                var products = productService.getAll();
                var res = this.aiConnector.initDataToPython(createRequestBody(products)).join();
                if(res == null || res.isEmpty()) {
                    throw new RuntimeException("AI recommendation server error: Unable to initialize product data");
                } else {
                    applyCache(res);
                }
                return;
            }
            if(!this.similarProductStore.isEmpty() && status == 0){
                var products = productService.getAll();
                var res = this.aiConnector.initDataToPython(createRequestBody(products)).join();
                if(res == null || res.isEmpty()) {
                    throw new RuntimeException("AI recommendation server error: Unable to update product cache");
                } else {
                    applyCache(res);
                }
                return;
            }
            // Nếu Python đã có cache nhưng Java chạy lại thì chỉ cần cập nhật kết quả
            if(status > 0 && status > this.similarProductStore.size()){
                this.aiConnector.refreshCache().thenAccept(this::applyCache);
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to build AI recommendation cache", e);
        }
    }

    @Override
    public void addNewProductToPython(Product product) {
        try {
            var res = this.aiConnector.addNewProductToPython(product).join();
            if(res == null || res.isEmpty())
                buildCache();
            else
                applyCache(res);
        } catch (Exception e) {
            throw new RuntimeException("Failed to add new product to AI recommendation system", e);
        }
    }
    // Tạo ra request để gửi cho Python. Gửi danh sách name
    private String createRequestBody(List<ProductView> products){
        var request = products.stream().map(p -> new ProductAiDTO(p.getId(),p.getName())).toList();
        return this.mapper.createObjectNode().putPOJO("products",request)
                .put("k_item", K_ITEM).toString();
    }

    private void applyCache(Map<Long, List<Long>> newCache){
        this.similarProductStore.putAll(newCache);
    }
}
