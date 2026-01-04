package com.ecommerce.backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class Material {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String materialName;
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
