package com.ecommerce.backend.config;

import com.ecommerce.backend.model.*;
import com.ecommerce.backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.Collections;

@Component
@RequiredArgsConstructor
public class DataSeeder implements CommandLineRunner {

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;

    @Override
    public void run(String... args) throws Exception {
        // Create Categories
        Category category1 = new Category();
        category1.setName("Dresses");
        category1.setImageUrl("Dresses");
        Category category2 = new Category();
        category2.setName("Jackets & Blazers");
        category2.setImageUrl("Dresses");
        Category category3 = new Category();
        category3.setImageUrl("Dresses");
        category3.setName("Coats");
        Category category4 = new Category();
        category4.setName("Lingerie & Nightwear");
        category4.setImageUrl("Dresses");
        categoryRepository.saveAll(Arrays.asList(category1, category2,category3, category4));
//
//        // Create Products
//        Product product1 = new Product();
//        product1.setName("Classic White T-Shirt");
//        product1.setDescription("A classic white t-shirt");
//        product1.setPrice(19.99);
//        product1.setImageUrl("/uploads/tshirt.jpg");
//        product1.setCategory(category1);
//
//        Product product2 = new Product();
//        product2.setName("Slim Fit Jeans");
//        product2.setDescription("A pair of slim fit jeans");
//        product2.setPrice(49.99);
//        product2.setImageUrl("/uploads/jeans.jpg");
//        product2.setCategory(category2);
//        productRepository.saveAll(Arrays.asList(product1, product2));
//
//        // Create Users
//        User user1 = new User();
//        user1.setUsername("john.doe");
//        user1.setPassword("password123");
//        user1.setEmail("john.doe@example.com");
//        user1.setOrders(Collections.emptyList());
//        userRepository.save(user1);
//
//        // Create a Cart for the User
//        Cart cart1 = new Cart();
//        cart1.setUser(user1);
//        cart1.setCartItems(Collections.emptyList());
//        cartRepository.save(cart1);
//        user1.setCart(cart1);
//        userRepository.save(user1);
//
//        // Create CartItems
//        CartItem cartItem1 = new CartItem();
//        cartItem1.setCart(cart1);
//        cartItem1.setProduct(product1);
//        cartItem1.setQuantity(2);
//        cartItemRepository.save(cartItem1);
//
//        // Create an Order
//        Order order1 = new Order();
//        order1.setUser(user1);
//        order1.setOrderItems(Collections.emptyList());
//        order1.setTotalPrice(39.98);
//        orderRepository.save(order1);
//
//        // Create OrderItems
//        OrderItem orderItem1 = new OrderItem();
//        orderItem1.setOrder(order1);
//        orderItem1.setProduct(product1);
//        orderItem1.setQuantity(2);
//        orderItem1.setPrice(19.99);
//        orderItemRepository.save(orderItem1);
    }
}
