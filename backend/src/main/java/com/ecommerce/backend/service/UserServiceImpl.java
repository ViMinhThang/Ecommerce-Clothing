package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.UserDTO;
import com.ecommerce.backend.dto.UserUpdateDTO;
import com.ecommerce.backend.dto.view.UserSearch;
import com.ecommerce.backend.dto.view.UserDetailView;
import com.ecommerce.backend.dto.view.UserItemView;
import com.ecommerce.backend.exception.ResourceNotFoundException;
import com.ecommerce.backend.mapper.UserMapper;
import com.ecommerce.backend.model.User;
import com.ecommerce.backend.model.UserRole;
import com.ecommerce.backend.repository.RoleRepository;
import com.ecommerce.backend.repository.UserRepository;
import com.ecommerce.backend.repository.UserRoleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.management.BadAttributeValueExpException;
import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService{
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;
    @Override
    public Page<UserItemView> getAllUsers(Pageable pageable) {
        return userRepository.findAll(PageRequest.of(pageable.getPageNumber()
                , pageable.getPageSize(), Sort.by("createdDate").descending())).map(UserMapper::toUserItemView);
    }

    @Override
    public User getUserById(long id) {
        return userRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found"));
    }


    @Override
    @Transactional
    public void createUser(UserDTO userDTO)  {
        var res = userRepository.findByUsername(userDTO.getUsername());
        if(res.isPresent())
            throw new RuntimeException("User is exist");
        if (userRepository.findByEmail(userDTO.getEmail()).isPresent()) {
            throw new RuntimeException("Email is exist");
        }
        var roles = roleRepository.findByNameIn(userDTO.getRoles());
        if(roles.isEmpty())
            throw new RuntimeException("Role is not exist");

        var user = userDTO.toUser();
        user = userRepository.save(user);
        List<UserRole> urs = new ArrayList<>();
        for(var r : roles){
            var ur = new UserRole();
            ur.setRole(r);
            ur.setUser(user);
            urs.add(ur);
        }
        userRoleRepository.saveAllAndFlush(urs);
    }

    @Override
    public User updateUser(long id, UserUpdateDTO userDTO) throws BadAttributeValueExpException {
        var user = userRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("User not found"));
        var res = userDTO.updateUser(user);
        return userRepository.save(res);
    }

    @Override
    public void deleteUser(long id) {
        var res = userRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("User not found"));
        res.setStatus("deleted");
        userRepository.saveAndFlush(res);
    }

    @Override
    public List<UserSearch> searchByName(String name) {
        return userRepository.searchByPrefix(name);
    }

    @Override
    public UserDetailView searchById(long id) {
        return userRepository.findById(id).map(UserMapper::toUserDetailView)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }
}
