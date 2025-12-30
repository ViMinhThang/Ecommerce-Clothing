package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.UserDTO;
import com.ecommerce.backend.dto.UserUpdateDTO;
import com.ecommerce.backend.dto.view.UserSearch;
import com.ecommerce.backend.dto.view.UserDetailView;
import com.ecommerce.backend.dto.view.UserItemView;
import com.ecommerce.backend.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import javax.management.BadAttributeValueExpException;
import java.util.List;

public interface UserService {
    Page<UserItemView> getAllUsers(Pageable pageable);
    User getUserById(long id);
    void createUser(UserDTO userDTO) ;
    User updateUser(long id, UserUpdateDTO userDTO) throws BadAttributeValueExpException;
    void deleteUser(long id);
    List<UserSearch> searchByName(String name);

    UserDetailView searchById(long id);
}
