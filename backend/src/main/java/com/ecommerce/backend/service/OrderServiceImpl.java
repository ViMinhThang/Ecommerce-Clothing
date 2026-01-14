package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.OrderDTO;
import com.ecommerce.backend.dto.view.OrderDetailView;
import com.ecommerce.backend.dto.view.OrderStatistics;
import com.ecommerce.backend.dto.view.OrderView;
import com.ecommerce.backend.mapper.OrderMapper;
import com.ecommerce.backend.model.Order;
import com.ecommerce.backend.model.OrderItem;
import com.ecommerce.backend.model.User;
import com.ecommerce.backend.model.Voucher;
import com.ecommerce.backend.repository.*;
import org.springframework.security.core.context.SecurityContextHolder;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;

@RequiredArgsConstructor
@Service
public class OrderServiceImpl implements OrderService {
    private final OrderRepository orderRepository;
    private final CartItemRepository cartItemRepository;
    private final CartRepository cartRepository;
    private final VoucherService voucherService;

    @Override
    public Page<OrderView> getAllOrders(Pageable pageable) {
        return orderRepository.findAll(
                PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), Sort.by("createdDate").descending()))
                .map(OrderMapper::toOrderView);
    }

    @Override
    public OrderDetailView getOrderById(long id) {
        return orderRepository.findById(id).map(OrderMapper::toOrderDetailView)
                .orElseThrow(() -> new RuntimeException("Not found"));
    }

    @Override
    @Transactional
    public OrderView createOrder(OrderDTO orderDTO) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (!(principal instanceof User)) {
            throw new IllegalStateException("User not authenticated. Please login to place an order.");
        }
        User user = (User) principal;

        var cart = cartRepository.findByUserId(user.getId());

        if (cart == null) {
            throw new IllegalStateException("User does not have a cart. Please add items to cart first.");
        }

        var cartItems = cartItemRepository.findByIdInAndCart(orderDTO.getCartItemIds(), cart);

        if (cartItems.isEmpty()) {
            throw new IllegalStateException(
                    "No valid cart items found for the given IDs: " + orderDTO.getCartItemIds());
        }

        var orderItems = new ArrayList<OrderItem>();

        var order = new Order();
        order.setStatus("pending");
        order.setUser(user);

        var sum = 0.0;
        for (var ct : cartItems) {
            var productVariants = ct.getProductVariants();
            var orderItem = new OrderItem();
            var quantity = ct.getQuantity();
            var price = productVariants.getPrice().getSalePrice();
            orderItem.setOrder(order);
            orderItem.setStatus("pending");
            orderItem.setProductVariants(productVariants);
            orderItem.setQuantity(quantity);
            orderItem.setPriceAtPurchase(price);
            orderItems.add(orderItem);
            sum += (quantity * price);
        }

        order.setOrderItems(orderItems);
        order.setTotalPrice(sum);

        double discountAmount = 0;
        double finalPrice = sum;

        if (orderDTO.getVoucherCode() != null && !orderDTO.getVoucherCode().trim().isEmpty()) {
            Voucher voucher = voucherService.applyVoucher(orderDTO.getVoucherCode(), sum);
            if (voucher != null) {
                discountAmount = ((VoucherServiceImpl) voucherService).calculateDiscount(voucher, sum);
                finalPrice = sum - discountAmount;
                order.setVoucher(voucher);
                voucherService.incrementUsedCount(voucher.getId());
            }
        }

        order.setDiscountAmount(discountAmount);
        order.setFinalPrice(finalPrice);

        Order savedOrder = orderRepository.save(order);

        cartItemRepository.deleteAll(cartItems);

        return OrderMapper.toOrderView(savedOrder);
    }

    @Override
    public Order updateOrder(long id, OrderDTO orderDTO) {
        return null;
    }

    @Override
    public void deleteOrder(long id) {
        var order = orderRepository.findById(id).orElseThrow(() -> new RuntimeException("Đơn hàng không tồn tại"));
        order.setStatus("deleted");
        orderRepository.save(order);
    }

    @Override
    public OrderStatistics orderStatistics() {
        // ----------- lấy thời gian ------------
        LocalDate today = LocalDate.now();

        LocalDate firstDayOfMonth = today.withDayOfMonth(1);
        LocalDate lastDayOfMonth = today.withDayOfMonth(today.lengthOfMonth());
        LocalDateTime startOfMonth = firstDayOfMonth.atStartOfDay();
        LocalDateTime endOfMonth = lastDayOfMonth.atTime(23, 59, 59, 999_999_999);

        LocalDate startDayOfWeek = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate endDayOfWeek = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
        LocalDateTime startOfWeek = startDayOfWeek.atStartOfDay();
        LocalDateTime endOfWeek = endDayOfWeek.atTime(23, 59, 59, 999_999_999);

        LocalDateTime startOfToday = today.atStartOfDay();
        LocalDateTime endOfToday = today.atTime(23, 59, 59, 999_999_999);

        var orders = orderRepository.findByCreatedDateBetween(startOfMonth, endOfMonth);
        // ----------- khai báo ------------
        int totalOrderByDay = 0;
        double totalPriceOrderByDay = 0.0;
        int totalOrderByWeek = 0;
        double totalPriceOrderByWeek = 0.0;
        int totalOrderByMonth = 0;
        double totalPriceOrderByMonth = 0.0;
        // ----------- Tổng theo thời gian ------------
        for (var o : orders) {
            var date = o.getCreatedDate();
            var price = o.getTotalPrice();
            var isCompleted = "completed".equals(o.getStatus());
            if (isCompleted && !date.isBefore(startOfToday) && !date.isAfter(endOfToday)) {
                totalOrderByDay++;
                totalPriceOrderByDay += price;
            }

            if (isCompleted && !date.isBefore(startOfWeek) && !date.isAfter(endOfWeek)) {
                totalOrderByWeek++;
                totalPriceOrderByWeek += price;
            }

            if (isCompleted && !date.isBefore(startOfMonth) && !date.isAfter(endOfMonth)) {
                totalOrderByMonth++;
                totalPriceOrderByMonth += price;
            }
        }

        return new OrderStatistics(
                totalOrderByDay, totalPriceOrderByDay,
                totalOrderByWeek, totalPriceOrderByWeek,
                totalOrderByMonth, totalPriceOrderByMonth);
    }

    @Override
    public Page<OrderView> getAllOrdersByStatus(String status, Pageable pageable) {
        return orderRepository.findAllByStatus(status, pageable).map(OrderMapper::toOrderView);
    }
}
