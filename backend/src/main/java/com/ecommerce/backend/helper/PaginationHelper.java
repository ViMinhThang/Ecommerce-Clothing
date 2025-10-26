package com.ecommerce.backend.helper;

import com.ecommerce.backend.exception.APIException;
import com.ecommerce.backend.response.BaseResponse;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.data.domain.*;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.function.Function;

@RequiredArgsConstructor
@Component
public class PaginationHelper {

    private final ModelMapper modelMapper;

    public <T, D, R extends BaseResponse<D>> R getPaginatedResponse(
            Page<T> page,
            Class<D> dtoClass,
            Function<List<D>, R> responseConstructor,
            String emptyMessage
    ) {
        List<T> content = page.getContent();
        if(content.isEmpty()){
            throw new APIException(emptyMessage);
        }

        List<D> dtoList = content.stream()
                .map(item -> modelMapper.map(item, dtoClass))
                .toList();

        R response = responseConstructor.apply(dtoList);
        response.setPageNumber(page.getNumber());
        response.setPageSize(page.getSize());
        response.setTotalElements(page.getTotalElements());
        response.setTotalPages(page.getTotalPages());
        response.setLastPage(page.isLast());

        return response;
    }
}
