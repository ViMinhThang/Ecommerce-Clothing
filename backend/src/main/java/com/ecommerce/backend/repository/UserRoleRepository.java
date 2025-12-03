package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.Role;
import com.ecommerce.backend.model.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
@Repository
public interface UserRoleRepository extends JpaRepository<UserRole, Long> {
}
