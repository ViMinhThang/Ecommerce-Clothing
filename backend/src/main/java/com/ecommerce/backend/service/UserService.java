package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.UserDTO;
import com.ecommerce.backend.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface UserService {
    Page<User> getAllUsers(Pageable pageable);
    User getUserById(long id);
    User createUser(UserDTO UserDTO);
    User updateUser(long id, UserDTO UserDTO);
    void deleteUser(long id);
}
