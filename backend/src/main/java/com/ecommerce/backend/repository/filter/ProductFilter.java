package com.ecommerce.backend.repository.filter;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
@Getter
@Setter
public class ProductFilter {
    private double minPrice;
    private double maxPrice;
    private boolean isSale;
    private String status;
    private List<String> sizes;
    private List<String> colors;
    private List<String> materials;
    private List<String> seasons;
}
