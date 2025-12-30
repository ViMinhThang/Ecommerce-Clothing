package com.ecommerce.backend.model;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "orders")
@EntityListeners(AuditingEntityListener.class)
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> orderItems;

    private double totalPrice;
    private String status;

    @Column(nullable = false, updatable = false)
    @CreatedDate
    private LocalDateTime createdDate;

    @Column(updatable = true, nullable = true)
    @LastModifiedDate
    private LocalDateTime updatedDate;

    @ManyToOne
    @JoinColumn(name = "updated_by")
    @LastModifiedBy
    private User updatedBy;
}
