package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.OrderDTO;
import com.ecommerce.backend.model.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface OrderService {
     Page<Order> getAllOrders(Pageable pageable);
    Order getOrderById(long id);
     Order createOrder(OrderDTO orderDTO);
     Order updateOrder(long id, OrderDTO orderDTO);
     void deleteOrder(long id);
}
