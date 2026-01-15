package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.OrderDTO;
import com.ecommerce.backend.dto.view.OrderDetailView;
import com.ecommerce.backend.dto.view.OrderStatistics;
import com.ecommerce.backend.dto.view.OrderView;
import com.ecommerce.backend.model.Order;
import com.ecommerce.backend.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Set;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {
    private final OrderService orderService;
    private static final Set<String> ALLOWED_SORT_FIELDS = Set.of("createdDate", "totalPrice", "status");

    @GetMapping
    public ResponseEntity<Page<OrderView>> getOrders(
            Pageable pageable,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "createdDate") String sortBy,
            @RequestParam(defaultValue = "DESC") String direction) {
        String sortField = (sortBy != null && ALLOWED_SORT_FIELDS.contains(sortBy)) ? sortBy : "createdDate";
        Sort.Direction sortDirection = Sort.Direction.DESC;
        if (direction != null) {
            try {
                sortDirection = Sort.Direction.fromString(direction);
            } catch (IllegalArgumentException e) {
                // Keep default DESC if invalid direction provided
            }
        }

        Sort sort = Sort.by(sortDirection, sortField);
        Pageable pageRequest = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), sort);

        Page<OrderView> result = (status == null || status.isBlank())
                ? orderService.getAllOrders(pageRequest)
                : orderService.getAllOrdersByStatus(status, pageRequest);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/{id}")
    public ResponseEntity<OrderDetailView> getOrderById(@PathVariable Long id) {
        return ResponseEntity.ok(orderService.getOrderById(id));
    }

    @PostMapping
    public ResponseEntity<OrderView> createOrder(@RequestBody OrderDTO orderDTO) {
        OrderView createdOrder = orderService.createOrder(orderDTO);
        return new ResponseEntity<>(createdOrder, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Order> updateOrder(@PathVariable Long id, @RequestBody OrderDTO OrderDTO) { // Changed
                                                                                                      // parameter to
                                                                                                      // OrderDTO
        Order updatedOrder = orderService.updateOrder(id, OrderDTO);
        return ResponseEntity.ok(updatedOrder);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteOrder(@PathVariable Long id) {
        orderService.deleteOrder(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/statistics")
    public ResponseEntity<OrderStatistics> statistics() {
        return ResponseEntity.ok(orderService.orderStatistics());
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<OrderView> updateOrderStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {
        String status = request.get("status");
        return ResponseEntity.ok(orderService.updateOrderStatus(id, status));
    }

}
