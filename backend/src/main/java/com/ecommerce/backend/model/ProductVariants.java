package com.ecommerce.backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
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
@NoArgsConstructor
@AllArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class ProductVariants {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @ManyToOne
    @JsonIgnore
    @JoinColumn(columnDefinition = "product_id")
    private Product product;
    @ManyToOne
    @JoinColumn(columnDefinition = "color_id")
    private Color color;
    @OneToOne
    @JoinColumn(columnDefinition = "price_id")
    private Price price;
    @ManyToOne
    @JoinColumn(columnDefinition = "size_id")
    private Size size;
    private String status;
    @Column(nullable = false, updatable = false)
    @CreatedDate
    private LocalDateTime createdDate;
    @Column(updatable = true, nullable = true)
    @LastModifiedDate
    private LocalDateTime updatedDate;
    @CreatedBy
    private User createdBy;
    @LastModifiedBy
    private User updatedBy;
}
