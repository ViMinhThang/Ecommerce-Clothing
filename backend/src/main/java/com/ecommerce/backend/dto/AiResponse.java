package com.ecommerce.backend.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Setter
@Getter
public class AiResponse {
    private Map<Long, List<Long>> result;
}
