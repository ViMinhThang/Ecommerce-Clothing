package com.ecommerce.backend.product.service;

import com.ecommerce.backend.exception.APIException;
import com.ecommerce.backend.exception.ResourceNotFoundException;
import com.ecommerce.backend.helper.PaginationHelper;
import com.ecommerce.backend.product.dtos.ColorDTO;
import com.ecommerce.backend.product.dtos.ColorResponse;
import com.ecommerce.backend.product.dtos.SizeDTO;
import com.ecommerce.backend.product.dtos.SizeResponse;
import com.ecommerce.backend.product.entity.Color;
import com.ecommerce.backend.product.entity.Size;
import com.ecommerce.backend.product.repositories.ColorRepository;
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
public class ColorServiceImpl implements ColorService {

    private final ColorRepository colorRepository;
    private final ModelMapper modelMapper;
    private final PaginationHelper paginationHelper;

    @Override
    public ColorResponse getAllColors(Integer pageNumber, Integer pageSize, String sortBy, String sortOrder) {
        Pageable pageable = PageRequest.of(pageNumber, pageSize,
                sortOrder.equalsIgnoreCase("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending()
        );
        Page<Color> page = colorRepository.findAll(pageable);

        return paginationHelper.getPaginatedResponse(
                page,
                ColorDTO.class,
                list -> {
                    ColorResponse response = new ColorResponse();
                    response.setContent(list);
                    return response;
                },
                "No color created till now."
        );
    }

    @Override
    public ColorDTO createColor(ColorDTO colorDTO) {
        Color color = modelMapper.map(colorDTO, Color.class);
        Color colorFromDb = colorRepository.findByName(color.getName());
        if (colorFromDb == null) {
            throw new APIException("Color with name " + color.getName() + " already exists.");
        }
        Color savedSize = colorRepository.save(color);
        return modelMapper.map(savedSize, ColorDTO.class);
    }

    @Override
    public ColorDTO deleteColor(Long colorId) {
        Color color = colorRepository.findById(colorId)
                .orElseThrow(() -> new ResourceNotFoundException("Color", "colorId", colorId));
        colorRepository.delete(color);
        return modelMapper.map(color, ColorDTO.class);
    }

    @Override
    public ColorDTO updateColor(ColorDTO colorDTO, Long colorId) {
        Color savedColor = colorRepository.findById(colorId)
                .orElseThrow(() -> new ResourceNotFoundException("Color","colorId",colorId));

        Color color = modelMapper.map(colorDTO, Color.class);
        color.setId(colorId);
        savedColor = colorRepository.save(color);
        return modelMapper.map(savedColor, ColorDTO.class);
    }
}
