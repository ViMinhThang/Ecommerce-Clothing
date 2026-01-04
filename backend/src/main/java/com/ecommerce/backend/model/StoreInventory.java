package com.ecommerce.backend.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
@NoArgsConstructor
public class StoreInventory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne
    private Store store;

    @ManyToOne
    private ProductVariants product;

    private int amount;

    private String status;

    @Column(nullable = false)
    @CreatedDate
    private LocalDateTime createdDate;

    @Column(updatable = true, nullable = true)
    @LastModifiedDate
    private LocalDateTime updatedDate;

    @ManyToOne
    @JoinColumn(name = "created_by")
    @CreatedBy
    private User createdBy;

    @ManyToOne
    @JoinColumn(name = "updated_by")
    @LastModifiedBy
    private User updatedBy;
}
