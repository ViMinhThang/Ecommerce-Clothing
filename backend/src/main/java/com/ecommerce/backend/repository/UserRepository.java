package com.ecommerce.backend.repository;

import com.ecommerce.backend.dto.view.UserSearch;
import com.ecommerce.backend.model.User;
import jakarta.validation.constraints.Email;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);

    @Query("SELECT u FROM User u LEFT JOIN FETCH u.userRoles ur LEFT JOIN FETCH ur.role WHERE u.username = :username")
    Optional<User> findByUsernameWithRoles(@Param("username") String username);

    @Query(value = "SELECT u.id, u.full_name, u.email FROM users as u WHERE LOWER(u.full_name) LIKE LOWER(CONCAT(:prefix, '%'))", nativeQuery = true)
    List<UserSearch> searchByPrefix(@Param("prefix") String prefix);

    Optional<User> findByEmail(@Email(message = "email không hợp lệ") String email);
}
