package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.SizeDTO; // Import SizeDTO
import com.ecommerce.backend.model.Size;
import com.ecommerce.backend.repository.SizeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SizeServiceImpl implements SizeService {

    private final SizeRepository sizeRepository;

    @Override
    public List<Size> getAllSizes() {
        return sizeRepository.findAll();
    }

    @Override
    public Size getSizeById(Long id) {
        return sizeRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Size not found with id: " + id));
    }

    @Override
    public Size createSize(SizeDTO sizeDTO) {
        Size size = new Size();
        size.setSizeName(sizeDTO.getSizeName());
        size.setStatus(sizeDTO.getStatus());
        return sizeRepository.save(size);
    }

    @Override
    public Size updateSize(Long id, SizeDTO sizeDTO) {
        Size existingSize = sizeRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Size not found with id: " + id));
        existingSize.setSizeName(sizeDTO.getSizeName());
        existingSize.setStatus(sizeDTO.getStatus());
        return sizeRepository.save(existingSize);
    }

    @Override
    public void deleteSize(Long id) {
        sizeRepository.deleteById(id);
    }

    @Override
    public Page<Size> searchSizes(String name, Pageable pageable) {
        return sizeRepository.findByNameContainingIgnoreCase(name, pageable);
    }
}