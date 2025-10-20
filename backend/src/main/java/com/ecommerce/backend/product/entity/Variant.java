package com.ecommerce.backend.product.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "variants")
public class Variant {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long variantId;

    private Double price;
    private Integer quantity;

    private String description;
    @ManyToOne
    @JoinColumn(name = "product_id")
    @ToString.Exclude
    private Product product;


    @ManyToOne
    @JoinColumn(name = "size_id")
    private Size size;
    private String SKU;
    @ManyToOne
    @JoinColumn(name = "color_id")
    private Color color;

    @OneToMany(
            mappedBy = "variant",
            cascade = CascadeType.ALL,
            orphanRemoval = true,
            fetch = FetchType.LAZY
    )
    @ToString.Exclude
    private List<VariantImage> images = new ArrayList<>();
}
