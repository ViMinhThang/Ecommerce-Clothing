package com.ecommerce.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CategoryView {
    private long id;
    private String name;
}
