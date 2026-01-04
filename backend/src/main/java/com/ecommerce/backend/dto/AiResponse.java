package com.ecommerce.backend.dto;

import java.util.List;

public class AiResponse {
    private List<List<Double>> vectors;

    public List<List<Double>> getVectors() {
        return vectors;
    }

    public void setVectors(List<List<Double>> vectors) {
        this.vectors = vectors;
    }
}
