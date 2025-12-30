package com.ecommerce.backend.mapper;

import com.ecommerce.backend.dto.view.UserDetailView;
import com.ecommerce.backend.dto.view.UserItemView;
import com.ecommerce.backend.model.Order;
import com.ecommerce.backend.model.User;

public class UserMapper {
    public static UserItemView toUserItemView(User user) {
        return UserItemView.builder()
                .id(user.getId())
                .name(user.getFullName())
                .role(user.getUserRoles().stream().map(userRole -> userRole.getRole().getName()).toList())
                .totalPrice(user.getOrders().stream().mapToDouble(Order::getTotalPrice).sum())
                .totalOrder(user.getOrders().size())
                .status(user.getStatus())
                .build();
    }

    public static UserDetailView toUserDetailView(User user) {
        return UserDetailView.builder()
                .name(user.getFullName())
                .email(user.getEmail())
                .role(user.getUserRoles().stream().map(userRole -> userRole.getRole().getName()).toList())
                .totalPrice(user.getOrders().stream().mapToDouble(Order::getTotalPrice).sum())
                .totalOrder(user.getOrders().size())
                .status(user.getStatus())
                .birthDay(user.getBirthDay())
                .build();
    }
}
