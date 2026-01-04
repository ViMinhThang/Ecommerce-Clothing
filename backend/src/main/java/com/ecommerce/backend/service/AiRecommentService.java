package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.view.ProductView;
import com.fasterxml.jackson.core.JsonProcessingException;

import java.util.List;

public interface AiRecommentService {
    List<ProductView> getSimilarProducts(long productId);
    public void buildCache() throws JsonProcessingException;
}
