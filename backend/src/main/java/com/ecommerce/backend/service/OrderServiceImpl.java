package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.OrderDTO;
import com.ecommerce.backend.model.Order;
import com.ecommerce.backend.repository.OrderItemRepository;
import com.ecommerce.backend.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class OrderServiceImpl implements OrderService{
    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;


    @Override
    public Page<Order> getAllOrders(Pageable pageable) {
        return orderRepository.findAll(PageRequest.of(pageable.getPageNumber()
                , pageable.getPageSize(), Sort.by("createdDate").descending()));
    }

    @Override
    public Order getOrderById(long id) {
        return orderRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found"));
    }

    @Override
    public Order createOrder(OrderDTO orderDTO) {
        return null;
    }

    @Override
    public Order updateOrder(long id, OrderDTO orderDTO) {
        return null;
    }

    @Override
    public void deleteOrder(long id) {
    }
}
