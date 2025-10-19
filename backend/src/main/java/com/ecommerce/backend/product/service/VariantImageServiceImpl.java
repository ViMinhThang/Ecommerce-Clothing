package com.ecommerce.backend.product.service;
import com.ecommerce.backend.product.dtos.VariantImageDTO;
import com.ecommerce.backend.product.entity.Variant;
import com.ecommerce.backend.product.entity.VariantImage;
import com.ecommerce.backend.product.repositories.VariantImageRepository;
import com.ecommerce.backend.product.repositories.VariantRepository;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VariantImageServiceImpl implements VariantImageService {

    private final VariantImageRepository variantImageRepository;
    private final VariantRepository variantRepository;
    private final ModelMapper modelMapper;

    public VariantImageDTO addImageToVariant(Long variantId, String imageUrl) {
        Variant variant = variantRepository.findById(variantId)
                .orElseThrow(() -> new RuntimeException("Variant not found"));

        VariantImage image = new VariantImage();
        image.setImageUrl(imageUrl);
        image.setVariant(variant);

        VariantImage saved = variantImageRepository.save(image);
        return modelMapper.map(saved, VariantImageDTO.class);
    }

    public List<VariantImageDTO> getImagesByVariant(Long variantId) {
        List<VariantImage> images = variantImageRepository.findByVariant_VariantId(variantId);
        return images.stream()
                .map(img -> modelMapper.map(img, VariantImageDTO.class))
                .collect(Collectors.toList());
    }

    @Override
    public void deletImage(VariantImageDTO imageDTO) {
        variantImageRepository.delete(imageDTO.getId());
    }
}
