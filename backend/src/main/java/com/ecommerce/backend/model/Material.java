package com.ecommerce.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
public class Material {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String materialName;
    private String status;
    @Column(nullable = false)
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
