package com.ecommerce.backend.mapper;

import com.ecommerce.backend.dto.view.OrderDetailView;
import com.ecommerce.backend.dto.view.OrderItemView;
import com.ecommerce.backend.dto.view.OrderView;
import com.ecommerce.backend.model.Order;
import com.ecommerce.backend.model.OrderItem;
import com.ecommerce.backend.model.ProductVariants;

import java.util.stream.Collectors;

public class OrderMapper {
    public static OrderView toOrderView(Order order) {
        return OrderView.builder()
                .id(order.getId())
                .buyerEmail(order.getUser() != null ? order.getUser().getEmail() : null)
                .totalPrice(order.getTotalPrice())
                .status(order.getStatus())
                .build();
    }

    public static OrderDetailView toOrderDetailView(Order order) {
        return OrderDetailView.builder()
                .id(order.getId())
                .buyerEmail(order.getUser() != null ? order.getUser().getEmail() : null)
                .totalPrice(order.getTotalPrice())
                .status(order.getStatus())
                .items(order.getOrderItems().stream()
                        .map(OrderMapper::toOrderItemView)
                        .collect(Collectors.toList())
                )
                .build();
    }

    public static OrderItemView toOrderItemView(OrderItem item) {
        ProductVariants pv = item.getProductVariants();

        String productName = null;
        String imageUrl = null;
        String size = null;
        String color = null;
        String material = null;

        if (pv != null) {
            if (pv.getProduct() != null) {
                productName = pv.getProduct().getName();     // đổi thành field thật trong Product
                imageUrl = pv.getProduct().getImageUrl();    // đổi thành field thật trong Product
            }
            if (pv.getSize() != null) {
                size = pv.getSize().getSizeName();              // hoặc getValue(), tuỳ model Size
            }
            if (pv.getColor() != null) {
                color = pv.getColor().getColorName();            // tuỳ model Color
            }
            if (pv.getMaterial() != null) {
                material = pv.getMaterial().getMaterialName();      // tuỳ model Material
            }
        }

        return OrderItemView.builder()
                .id(item.getId())
                .productName(productName)
                .size(size)
                .color(color)
                .material(material)
                .imageUrl(imageUrl)
                .priceAtPurchase(item.getPriceAtPurchase())
                .quantity(item.getQuantity())
                .build();
    }
}
