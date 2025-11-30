package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.OrderDTO;
import com.ecommerce.backend.dto.view.OrderDetailView;
import com.ecommerce.backend.dto.view.OrderStatistics;
import com.ecommerce.backend.dto.view.OrderView;
import com.ecommerce.backend.model.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface OrderService {
     Page<OrderView> getAllOrders(Pageable pageable);
     OrderDetailView getOrderById(long id);
     Order createOrder(OrderDTO orderDTO);
     Order updateOrder(long id, OrderDTO orderDTO);
     void deleteOrder(long id);
     OrderStatistics orderStatistics();
     Page<OrderView> getAllOrdersByStatus(String status, Pageable pageable);
}
