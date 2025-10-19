package com.ecommerce.backend.response;

import lombok.Data;

import java.util.List;

@Data
public abstract class BaseResponse<D> {
    private List<D> content;
    private int pageNumber;
    private int pageSize;
    private long totalElements;
    private int totalPages;
    private boolean lastPage;
}
