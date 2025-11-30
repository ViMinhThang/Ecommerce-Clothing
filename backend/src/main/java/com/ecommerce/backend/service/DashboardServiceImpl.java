package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.view.DashBoardView;
import com.ecommerce.backend.model.Order;
import com.ecommerce.backend.repository.OrderRepository;
import com.ecommerce.backend.repository.ProductRepository;
import com.ecommerce.backend.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@AllArgsConstructor
@Service
public class DashboardServiceImpl  implements DashboardService{
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final OrderRepository orderRepository;

    @Override
    public DashBoardView getInit() {
        var totalUser = userRepository.count();
        var totalProduct = productRepository.count();
        var totalOrders = orderRepository.count();
        var totalRevenue = orderRepository.sumTotalPriceByStatus("completed");
        return new DashBoardView(totalRevenue,totalOrders,totalProduct,totalUser);
    }
}
