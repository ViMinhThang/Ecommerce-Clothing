package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.StoreInventory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StoreInventoryRepository extends JpaRepository<StoreInventory, Long> {

    /**
     * Find inventory by product variant ID
     */
    Optional<StoreInventory> findByProductId(Long productVariantId);

    /**
     * Find inventory by product variant ID and store ID
     */
    Optional<StoreInventory> findByProductIdAndStoreId(Long productVariantId, Long storeId);

    /**
     * Find all inventory for a specific store
     */
    List<StoreInventory> findByStoreId(Long storeId);

    /**
     * Find low stock items (amount below threshold)
     */
    @Query("SELECT si FROM StoreInventory si WHERE si.amount <= :threshold AND si.status = 'active'")
    List<StoreInventory> findLowStockItems(@Param("threshold") int threshold);

    /**
     * Find out of stock items
     */
    @Query("SELECT si FROM StoreInventory si WHERE si.amount = 0 AND si.status = 'active'")
    List<StoreInventory> findOutOfStockItems();

    /**
     * Get total stock across all stores for a variant
     */
    @Query("SELECT COALESCE(SUM(si.amount), 0) FROM StoreInventory si WHERE si.product.id = :variantId AND si.status = 'active'")
    int getTotalStockByVariantId(@Param("variantId") Long variantId);

    /**
     * Check if variant has sufficient stock
     */
    @Query("SELECT CASE WHEN SUM(si.amount) >= :quantity THEN true ELSE false END " +
           "FROM StoreInventory si WHERE si.product.id = :variantId AND si.status = 'active'")
    boolean hasSufficientStock(@Param("variantId") Long variantId, @Param("quantity") int quantity);

    /**
     * Find all active inventory records
     */
    List<StoreInventory> findByStatus(String status);
}
