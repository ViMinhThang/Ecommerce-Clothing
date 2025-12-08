package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Data;

public interface CategoryView {
    long getId();
    String getName();
    String getImageUrl();
}
