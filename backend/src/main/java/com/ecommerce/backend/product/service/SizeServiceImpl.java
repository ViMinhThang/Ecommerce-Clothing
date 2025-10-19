package com.ecommerce.backend.product.service;

import com.ecommerce.backend.category.dtos.CategoryDTO;
import com.ecommerce.backend.category.entity.Category;
import com.ecommerce.backend.exception.APIException;
import com.ecommerce.backend.exception.ResourceNotFoundException;
import com.ecommerce.backend.helper.PaginationHelper;
import com.ecommerce.backend.product.dtos.SizeDTO;
import com.ecommerce.backend.product.dtos.SizeResponse;
import com.ecommerce.backend.product.entity.Size;
import com.ecommerce.backend.product.repositories.SizeRepository;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SizeServiceImpl implements SizeService {

    private final SizeRepository sizeRepository;
    private final ModelMapper modelMapper;
    private final PaginationHelper paginationHelper;
    @Override
    public SizeResponse getAllSizes(Integer pageNumber, Integer pageSize, String sortBy, String sortOrder) {
        Pageable pageable = PageRequest.of(pageNumber, pageSize,
                sortOrder.equalsIgnoreCase("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending()
        );
        Page<Size> page = sizeRepository.findAll(pageable);

        return paginationHelper.getPaginatedResponse(
                page,
                SizeDTO.class,
                list -> {
                    SizeResponse response = new SizeResponse();
                    response.setContent(list);
                    return response;
                },
                "No size created till now."
        );
    }

    @Override
    public SizeDTO createSize(SizeDTO sizeDTO) {
        Size size = modelMapper.map(sizeDTO, Size.class);
        Size sizeFromDb = sizeRepository.findByName(size.getName());
        if(sizeFromDb == null){
            throw new APIException("Size with name " + size.getName() + " already exists.");
        }
        Size savedSize = sizeRepository.save(size);
        return modelMapper.map(savedSize,SizeDTO.class);

    }

    @Override
    public SizeDTO deleteSize(Long sizeId) {
        Size size = sizeRepository.findById(sizeId)
                .orElseThrow(()->new ResourceNotFoundException("Size","sizeId",sizeId));
        sizeRepository.delete(size);
        return modelMapper.map(size,SizeDTO.class);
    }

    @Override
    public SizeDTO updateSize(SizeDTO sizeDTO, Long sizeId) {
        Size saveSized = sizeRepository.findById(sizeId)
                .orElseThrow(() -> new ResourceNotFoundException("Size","sizeId",sizeId));

        Size size = modelMapper.map(sizeDTO, Size.class);
        size.setId(sizeId);
        saveSized = sizeRepository.save(size);
        return modelMapper.map(saveSized, SizeDTO.class);
    }
}
