package com.ecommerce.backend.product.service;

import com.ecommerce.backend.File.service.FileService;
import com.ecommerce.backend.exception.ResourceNotFoundException;
import com.ecommerce.backend.helper.PaginationHelper;
import com.ecommerce.backend.product.dtos.*;
import com.ecommerce.backend.product.entity.*;
import com.ecommerce.backend.product.repositories.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Service
@RequiredArgsConstructor
public class VariantServiceImpl implements VariantService {

    private final VariantRepository variantRepository;
    private final VariantImageService variantImageService;
    private final ModelMapper modelMapper;
    private final PaginationHelper paginationHelper;
    private final ProductRepository productRepository;
    private final ColorRepository colorRepository;
    private final SizeRepository sizeRepository;
    private final FileService fileService;
    private final VariantImageRepository variantImageRepository;

    @Override
    public VariantResponse getAllVariants(Long productId, Integer pageNumber, Integer pageSize, String sortBy, String sortOrder) {
        return null;
    }

    @Override
    public VariantDTO createVariant(VariantDTO variantDTO) {
        return null;
    }

    @Transactional
    @Override
    public void deleteVariant(Long variantId) {
        Variant variant = variantRepository.findById(variantId)
                .orElseThrow(() -> new ResourceNotFoundException("Variant", "variantId", variantId));
        variant.getImages().forEach(image->variantImageService.deletImage(modelMapper.map(image, VariantImageDTO.class)));
        variantRepository.delete(variantId);
    }

    @Override
    public VariantDTO updateVariant(VariantDTO variantDTO, Long variantId) {
        return null;
    }

    @Override
    public VariantDetailResponse getVariantDetails(Long productId, Long variantId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product", "productId", productId));

        Variant variant = variantRepository.findById(variantId)
                .orElseThrow(() -> new ResourceNotFoundException("Variant", "variantId", variantId));

        List<VariantDTO> variantList = variantRepository.findByProductAndVariantIdNot(product, variantId)
                .stream().map(v->modelMapper.map(variant,VariantDTO.class)).toList();
        VariantDetailResponse variantDetailResponse = new VariantDetailResponse();
        variantDetailResponse.setProductId(product.getProductId());
        variantDetailResponse.setProductName(product.getProductName());
        variantDetailResponse.setContent(modelMapper.map(variant, VariantDTO.class));
        variantDetailResponse.setVariants(variantList);
        return variantDetailResponse;
    }

    @Override
    public VariantDTO updateVariantInfo(VariantInfoRequest variantInfoRequest) {
        Color color = colorRepository.findByName(variantInfoRequest.getColor());
        Size size = sizeRepository.findByName(variantInfoRequest.getSize());
        Variant variant = variantRepository.findById(variantInfoRequest.getVariantId())
                .orElseThrow(() -> new ResourceNotFoundException("Variant", "variantId", variantInfoRequest.getVariantId()));
        variant.setPrice(variantInfoRequest.getPrice());
        variant.setColor(color);
        variant.setSize(size);
        variant.setSKU(variantInfoRequest.getSKU());
        variant.setDescription(variantInfoRequest.getDescription());
        VariantDTO variantDTO = modelMapper.map(variantRepository.save(variant), VariantDTO.class);
        return variantDTO;
    }

    @Override
    public String updateVariantStock(Integer quantity, String variantId) {
        Variant variant = variantRepository.findById(Long.valueOf(variantId))
                .orElseThrow(() -> new ResourceNotFoundException("Variant", "variantId", variantId));
        variant.setQuantity(quantity);
        variantRepository.save(variant);
        return "Update Quantity Successfully";
    }

    @Override
    public VariantImageDTO uploadImages(MultipartFile file,Long variantId) throws IOException {
            Variant variant = variantRepository.findById(variantId)
                    .orElseThrow(() -> new ResourceNotFoundException("Variant", "variantId", variantId));
            String imageUrl = fileService.saveFile(file);
            VariantImage img = new VariantImage();
            img.setVariant(variant);
            img.setImageUrl(imageUrl);
            VariantImageDTO variantImageDTO = modelMapper.map(variantImageRepository.save(img), VariantImageDTO.class);
            return variantImageDTO;
    }

    @Override
    public String deleteImage(String id) {
        VariantImage variantImage = variantImageRepository.findById(Long.valueOf(id))
                .orElseThrow(() -> new ResourceNotFoundException("VariantImage", "variantImage", id));
        String imageUrl = variantImage.getImageUrl().replace("http://localhost:8080/uploads/","");
        fileService.deleteImage(imageUrl);
        variantImageRepository.delete(variantImage);
        return "Delete Image Successfully";
    }

}
