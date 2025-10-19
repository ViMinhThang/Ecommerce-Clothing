package com.ecommerce.backend.product.service;

import com.ecommerce.backend.category.entity.Category;
import com.ecommerce.backend.category.repositories.CategoryRepository;
import com.ecommerce.backend.exception.APIException;
import com.ecommerce.backend.exception.ResourceNotFoundException;
import com.ecommerce.backend.helper.PaginationHelper;

import com.ecommerce.backend.product.dtos.ProductDTO;
import com.ecommerce.backend.product.dtos.ProductResponse;
import com.ecommerce.backend.product.entity.Product;
import com.ecommerce.backend.product.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final ModelMapper modelMapper;
    private final CategoryRepository categoryRepository;
    private final PaginationHelper paginationHelper;

    @Override
    public ProductDTO addProduct(Long categoryId, ProductDTO productDTO) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Category", "categoryId", categoryId));

        boolean isProductNotPresent = true;

        List<Product> products = category.getProducts();
        for (Product value : products) {
            if (value.getProductName().equals(productDTO.getProductName())) {
                isProductNotPresent = false;
                break;
            }
        }

        if (isProductNotPresent) {
            Product product = modelMapper.map(productDTO, Product.class);
            product.setCategory(category);
            Product savedProduct = productRepository.save(product);
            return modelMapper.map(savedProduct, ProductDTO.class);
        } else {
            throw new APIException("Product already exist!!");
        }
    }

    @Override
    public ProductResponse getAllProducts(Integer pageNumber, Integer pageSize, String sortBy, String sortOrder, String keyword, String category) {
        Pageable pageable = PageRequest.of(pageNumber, pageSize,
                sortOrder.equalsIgnoreCase("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending()
        );
        Page<Product> page = productRepository.findAll(pageable);

        return paginationHelper.getPaginatedResponse(
                page,
                ProductDTO.class,
                list -> {
                    ProductResponse response = new ProductResponse();
                    response.setContent(list);
                    return response;
                },
                "No product created till now."
        );
    }

    @Override
    public ProductResponse searchByCategory(Long categoryId, Integer pageNumber, Integer pageSize, String sortBy, String sortOrder) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Category", "categoryId", categoryId));
        Pageable pageable = PageRequest.of(pageNumber, pageSize,
                sortOrder.equalsIgnoreCase("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending()
        );
        Page<Product> pageProducts = productRepository.findByCategoryOrderByProductNameAsc(category, pageable);
        return paginationHelper.getPaginatedResponse(
                pageProducts,
                ProductDTO.class,
                list -> {
                    ProductResponse response = new ProductResponse();
                    response.setContent(list);
                    return response;
                },
                "No product created till now."
        );
    }

    @Override
    public ProductResponse searchProductByKeyword(String keyword, Integer pageNumber, Integer pageSize, String sortBy, String sortOrder) {
        Sort sortByAndOrder = sortOrder.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();

        Pageable pageDetails = PageRequest.of(pageNumber, pageSize, sortByAndOrder);
        Page<Product> pageProducts = productRepository.findByProductNameLikeIgnoreCase('%' + keyword + '%', pageDetails);
        return paginationHelper.getPaginatedResponse(
                pageProducts,
                ProductDTO.class,
                list -> {
                    ProductResponse response = new ProductResponse();
                    response.setContent(list);
                    return response;
                },
                "No product created till now."
        );
    }

    @Override
    public ProductDTO updateProduct(Long productId, ProductDTO productDTO) {
        Product productFromDb = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product", "productId", productId));

        Product product = modelMapper.map(productDTO, Product.class);

        productFromDb.setProductName(product.getProductName());
        productFromDb.setAvailable(product.getAvailable());
        Product savedProduct = productRepository.save(productFromDb);

        return modelMapper.map(savedProduct, ProductDTO.class);
    }

    @Override
    public ProductDTO deleteProduct(Long productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product", "productId", productId));

//        List<Cart> carts = cartRepository.findCartsByProductId(productId);
//        carts.forEach(cart -> cartService.deleteProductFromCart(cart.getCartId(), productId));

        productRepository.delete(product);
        return modelMapper.map(product, ProductDTO.class);
    }

    @Override
    public ProductDTO updateProductImage(Long productId, Long variantId, MultipartFile image) {
        return null;
    }

    @Override
    public ProductResponse getAllProductsForAdmin(Integer pageNumber, Integer pageSize, String sortBy, String sortOrder) {
        Sort sortByAndOrder = sortOrder.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();

        Pageable pageDetails = PageRequest.of(pageNumber, pageSize, sortByAndOrder);
        Page<Product> pageProducts = productRepository.findAll(pageDetails);
        return paginationHelper.getPaginatedResponse(
                pageProducts,
                ProductDTO.class,
                list -> {
                    ProductResponse response = new ProductResponse();
                    response.setContent(list);
                    return response;
                },
                "No product created till now."
        );
    }
}
