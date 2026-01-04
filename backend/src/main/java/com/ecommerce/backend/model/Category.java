package com.ecommerce.backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name; // Renamed from title
    private String description; // Added description field
    private String imageUrl;
    private String status; // Added status field

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