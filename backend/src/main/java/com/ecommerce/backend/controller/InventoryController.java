package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.InventoryDTO;
import com.ecommerce.backend.dto.StockCheckResponse;
import com.ecommerce.backend.dto.UpdateInventoryRequest;
import com.ecommerce.backend.service.InventoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/inventory")
@RequiredArgsConstructor
public class InventoryController {

    private final InventoryService inventoryService;

    /**
     * Get all inventory items
     */
    @GetMapping
    public ResponseEntity<List<InventoryDTO>> getAllInventory() {
        return ResponseEntity.ok(inventoryService.getAllInventory());
    }

    /**
     * Get inventory for a specific product variant
     */
    @GetMapping("/variant/{variantId}")
    public ResponseEntity<InventoryDTO> getInventoryByVariant(@PathVariable Long variantId) {
        return ResponseEntity.ok(inventoryService.getInventoryByVariantId(variantId));
    }

    /**
     * Get inventory for a specific store
     */
    @GetMapping("/store/{storeId}")
    public ResponseEntity<List<InventoryDTO>> getInventoryByStore(@PathVariable Long storeId) {
        return ResponseEntity.ok(inventoryService.getInventoryByStoreId(storeId));
    }

    /**
     * Check stock availability for a variant
     */
    @GetMapping("/check/{variantId}")
    public ResponseEntity<StockCheckResponse> checkStock(@PathVariable Long variantId) {
        return ResponseEntity.ok(inventoryService.checkStock(variantId));
    }

    /**
     * Check if sufficient stock for quantity
     */
    @GetMapping("/check/{variantId}/{quantity}")
    public ResponseEntity<Boolean> hasSufficientStock(
            @PathVariable Long variantId,
            @PathVariable int quantity) {
        boolean hasStock = inventoryService.hasSufficientStock(variantId, quantity);
        return ResponseEntity.ok(hasStock);
    }

    /**
     * Get low stock items
     */
    @GetMapping("/low-stock")
    public ResponseEntity<List<InventoryDTO>> getLowStockItems(
            @RequestParam(defaultValue = "10") int threshold) {
        return ResponseEntity.ok(inventoryService.getLowStockItems(threshold));
    }

    /**
     * Get out of stock items
     */
    @GetMapping("/out-of-stock")
    public ResponseEntity<List<InventoryDTO>> getOutOfStockItems() {
        return ResponseEntity.ok(inventoryService.getOutOfStockItems());
    }

    /**
     * Update inventory (set, add, or subtract stock)
     */
    @PutMapping("/update")
    public ResponseEntity<InventoryDTO> updateInventory(@RequestBody UpdateInventoryRequest request) {
        return ResponseEntity.ok(inventoryService.updateInventory(request));
    }

    /**
     * Create new inventory record
     */
    @PostMapping("/create")
    public ResponseEntity<InventoryDTO> createInventory(
            @RequestParam Long storeId,
            @RequestParam Long variantId,
            @RequestParam int initialStock) {
        InventoryDTO created = inventoryService.createInventory(storeId, variantId, initialStock);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * Reserve stock (for order processing)
     */
    @PostMapping("/reserve")
    public ResponseEntity<Void> reserveStock(
            @RequestParam Long variantId,
            @RequestParam int quantity) {
        try {
            inventoryService.reserveStock(variantId, quantity);
            return ResponseEntity.ok().build();
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
    }

    /**
     * Release stock (for order cancellation)
     */
    @PostMapping("/release")
    public ResponseEntity<Void> releaseStock(
            @RequestParam Long variantId,
            @RequestParam int quantity) {
        inventoryService.releaseStock(variantId, quantity);
        return ResponseEntity.ok().build();
    }
}
