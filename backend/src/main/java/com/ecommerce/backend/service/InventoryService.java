package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.InventoryDTO;
import com.ecommerce.backend.dto.StockCheckResponse;
import com.ecommerce.backend.dto.UpdateInventoryRequest;

import java.util.List;

public interface InventoryService {

    /**
     * Get inventory for a specific product variant
     */
    InventoryDTO getInventoryByVariantId(Long variantId);

    /**
     * Get all inventory for a store
     */
    List<InventoryDTO> getInventoryByStoreId(Long storeId);

    /**
     * Get low stock items (below threshold)
     */
    List<InventoryDTO> getLowStockItems(int threshold);

    /**
     * Get out of stock items
     */
    List<InventoryDTO> getOutOfStockItems();

    /**
     * Update inventory (set, add, or subtract)
     */
    InventoryDTO updateInventory(UpdateInventoryRequest request);

    /**
     * Check stock availability for a variant
     */
    StockCheckResponse checkStock(Long variantId);

    /**
     * Check if sufficient stock is available for purchase
     */
    boolean hasSufficientStock(Long variantId, int quantity);

    /**
     * Reserve stock for order (deduct inventory)
     */
    void reserveStock(Long variantId, int quantity);

    /**
     * Release stock (return to inventory, e.g., when order cancelled)
     */
    void releaseStock(Long variantId, int quantity);

    /**
     * Initialize inventory for a variant
     */
    InventoryDTO createInventory(Long storeId, Long variantId, int initialStock);

    /**
     * Get all inventory items
     */
    List<InventoryDTO> getAllInventory();
}
