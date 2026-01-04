package com.ecommerce.backend.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
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
    @JoinColumn(name = "product_id")
    @JsonBackReference
    @JsonIgnore
    private Product product;

    @ManyToOne
    @JoinColumn(name = "color_id")
    private Color color;

    @OneToOne
    @JoinColumn(name = "price_id")
    private Price price;

    @ManyToOne
    @JoinColumn(name = "size_id")
    private Size size;
    @ManyToOne
    @JoinColumn(name = "season_id")
    private Season season;
    @ManyToOne
    @JoinColumn(name = "material_id")
    private Material material;
    private String status;

    @Column(nullable = false, updatable = false)
    @CreatedDate
    @JsonIgnore
    private LocalDateTime createdDate;

    @Column(updatable = true, nullable = true)
    @LastModifiedDate
    @JsonIgnore
    private LocalDateTime updatedDate;

    @ManyToOne
    @JoinColumn(name = "created_by")
    @CreatedBy
    @JsonIgnore
    private User createdBy;

    @ManyToOne
    @JoinColumn(name = "updated_by")
    @LastModifiedBy
    @JsonIgnore
    private User updatedBy;
}
