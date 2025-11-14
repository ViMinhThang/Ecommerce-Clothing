package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.UserDTO;
import com.ecommerce.backend.model.User;
import com.ecommerce.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService{
    private final UserRepository UserRepository;

    @Override
    public Page<User> getAllUsers(Pageable pageable) {
        return UserRepository.findAll(PageRequest.of(pageable.getPageNumber()
                , pageable.getPageSize(), Sort.by("createdDate").descending()));
    }

    @Override
    public User getUserById(long id) {
        return UserRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found"));
    }

    @Override
    public User createUser(UserDTO UserDTO) {
        return null;
    }

    @Override
    public User updateUser(long id, UserDTO UserDTO) {
        return null;
    }

    @Override
    public void deleteUser(long id) {
    }
}
