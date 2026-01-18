package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.InventoryDTO;
import com.ecommerce.backend.dto.StockCheckResponse;
import com.ecommerce.backend.dto.UpdateInventoryRequest;
import com.ecommerce.backend.model.ProductVariants;
import com.ecommerce.backend.model.Store;
import com.ecommerce.backend.model.StoreInventory;
import com.ecommerce.backend.repository.ProductVariantsRepository;
import com.ecommerce.backend.repository.StoreInventoryRepository;
import com.ecommerce.backend.repository.StoreRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class InventoryServiceImpl implements InventoryService {

    private final StoreInventoryRepository inventoryRepository;
    private final StoreRepository storeRepository;
    private final ProductVariantsRepository variantsRepository;

    private static final int LOW_STOCK_THRESHOLD = 10;

    @Override
    public InventoryDTO getInventoryByVariantId(Long variantId) {
        StoreInventory inventory = inventoryRepository.findByProductId(variantId)
                .orElse(null);
        
        if (inventory == null) {
            // Return empty inventory if not found
            ProductVariants variant = variantsRepository.findById(variantId)
                    .orElseThrow(() -> new EntityNotFoundException("Product variant not found"));
            return createEmptyInventoryDTO(variant);
        }
        
        return mapToDTO(inventory);
    }

    @Override
    public List<InventoryDTO> getInventoryByStoreId(Long storeId) {
        return inventoryRepository.findByStoreId(storeId).stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<InventoryDTO> getLowStockItems(int threshold) {
        return inventoryRepository.findLowStockItems(threshold).stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<InventoryDTO> getOutOfStockItems() {
        return inventoryRepository.findOutOfStockItems().stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Override
    @SuppressWarnings("null")
    public InventoryDTO updateInventory(UpdateInventoryRequest request) {
        StoreInventory inventory = inventoryRepository
                .findByProductIdAndStoreId(request.getProductVariantId(), request.getStoreId())
                .orElseGet(() -> {
                    // Create new inventory if doesn't exist
                    StoreInventory newInventory = new StoreInventory();
                    Store store = storeRepository.findById(request.getStoreId())
                            .orElseThrow(() -> new EntityNotFoundException("Store not found"));
                    ProductVariants variant = variantsRepository.findById(request.getProductVariantId())
                            .orElseThrow(() -> new EntityNotFoundException("Product variant not found"));
                    
                    newInventory.setStore(store);
                    newInventory.setProduct(variant);
                    newInventory.setAmount(0);
                    newInventory.setStatus("active");
                    return newInventory;
                });

        // Apply operation
        switch (request.getOperation().toLowerCase()) {
            case "set":
                inventory.setAmount(request.getAmount());
                break;
            case "add":
                inventory.setAmount(inventory.getAmount() + request.getAmount());
                break;
            case "subtract":
                int newAmount = inventory.getAmount() - request.getAmount();
                if (newAmount < 0) {
                    throw new IllegalArgumentException("Cannot subtract more than available stock");
                }
                inventory.setAmount(newAmount);
                break;
            default:
                throw new IllegalArgumentException("Invalid operation. Use 'set', 'add', or 'subtract'");
        }

        inventory = inventoryRepository.save(inventory);
        return mapToDTO(inventory);
    }

    @Override
    public StockCheckResponse checkStock(Long variantId) {
        int totalStock = inventoryRepository.getTotalStockByVariantId(variantId);
        
        String stockStatus;
        boolean isLowStock;
        
        if (totalStock == 0) {
            stockStatus = "OUT_OF_STOCK";
            isLowStock = false;
        } else if (totalStock <= LOW_STOCK_THRESHOLD) {
            stockStatus = "LOW_STOCK";
            isLowStock = true;
        } else {
            stockStatus = "IN_STOCK";
            isLowStock = false;
        }

        return StockCheckResponse.builder()
                .variantId(variantId)
                .availableStock(totalStock)
                .inStock(totalStock > 0)
                .isLowStock(isLowStock)
                .stockStatus(stockStatus)
                .build();
    }

    @Override
    public boolean hasSufficientStock(Long variantId, int quantity) {
        int totalStock = inventoryRepository.getTotalStockByVariantId(variantId);
        return totalStock >= quantity;
    }

    @Override
    @SuppressWarnings("null")
    public void reserveStock(Long variantId, int quantity) {
        if (!hasSufficientStock(variantId, quantity)) {
            throw new IllegalStateException("Insufficient stock available");
        }

        // Find inventory with sufficient stock
        StoreInventory inventory = inventoryRepository.findByProductId(variantId)
                .orElseThrow(() -> new EntityNotFoundException("Inventory not found for variant"));

        if (inventory.getAmount() < quantity) {
            throw new IllegalStateException("Insufficient stock in inventory");
        }

        inventory.setAmount(inventory.getAmount() - quantity);
        inventoryRepository.save(inventory);
    }

    @Override
    @SuppressWarnings("null")
    public void releaseStock(Long variantId, int quantity) {
        StoreInventory inventory = inventoryRepository.findByProductId(variantId)
                .orElseThrow(() -> new EntityNotFoundException("Inventory not found for variant"));

        inventory.setAmount(inventory.getAmount() + quantity);
        inventoryRepository.save(inventory);
    }

    @Override
    @SuppressWarnings("null")
    public InventoryDTO createInventory(Long storeId, Long variantId, int initialStock) {
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new EntityNotFoundException("Store not found"));
        ProductVariants variant = variantsRepository.findById(variantId)
                .orElseThrow(() -> new EntityNotFoundException("Product variant not found"));

        StoreInventory inventory = new StoreInventory();
        inventory.setStore(store);
        inventory.setProduct(variant);
        inventory.setAmount(initialStock);
        inventory.setStatus("active");

        inventory = inventoryRepository.save(inventory);
        return mapToDTO(inventory);
    }

    @Override
    public List<InventoryDTO> getAllInventory() {
        return inventoryRepository.findByStatus("active").stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    // Helper methods
    private InventoryDTO mapToDTO(StoreInventory inventory) {
        InventoryDTO dto = new InventoryDTO();
        dto.setId(inventory.getId());
        dto.setStoreId(inventory.getStore().getId());
        dto.setStoreName(inventory.getStore().getName());
        dto.setProductVariantId(inventory.getProduct().getId());
        
        ProductVariants variant = inventory.getProduct();
        dto.setProductName(variant.getProduct() != null ? variant.getProduct().getName() : "Unknown");
        
        // Build variant info string
        StringBuilder variantInfo = new StringBuilder();
        if (variant.getSize() != null) {
            variantInfo.append("Size: ").append(variant.getSize().getSizeName());
        }
        if (variant.getColor() != null) {
            if (variantInfo.length() > 0) variantInfo.append(", ");
            variantInfo.append("Color: ").append(variant.getColor().getColorName());
        }
        if (variant.getMaterial() != null) {
            if (variantInfo.length() > 0) variantInfo.append(", ");
            variantInfo.append("Material: ").append(variant.getMaterial().getMaterialName());
        }
        dto.setVariantInfo(variantInfo.toString());
        
        dto.setAmount(inventory.getAmount());
        dto.setStatus(inventory.getStatus());
        
        return dto;
    }

    private InventoryDTO createEmptyInventoryDTO(ProductVariants variant) {
        InventoryDTO dto = new InventoryDTO();
        dto.setProductVariantId(variant.getId());
        dto.setProductName(variant.getProduct() != null ? variant.getProduct().getName() : "Unknown");
        dto.setAmount(0);
        dto.setStatus("out_of_stock");
        return dto;
    }
}
