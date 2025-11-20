package com.ecommerce.backend.repository;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public interface FilterView {
    String getSizes();
    String getMaterials();
    String getColors();
    String getSeasons();
    double getMinPrice();
    double getMaxPrice();

    default List<String> getSizeList() {
        return convertToList(getSizes());
    }

    default List<String> getMaterialList() {
        return convertToList(getMaterials());
    }

    default List<String> getColorList() {
        return convertToList(getColors());
    }

    default List<String> getSeasonList() {
        return convertToList(getSeasons());
    }

    // Hàm private hỗ trợ (Java 9+) hoặc copy logic vào từng hàm trên nếu dùng Java 8
    private List<String> convertToList(String data) {
        if (data == null || data.isEmpty()) {
            return Collections.emptyList();
        }
        return Arrays.asList(data.split(","));
    }
}
