package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.view.RoleView;
import com.ecommerce.backend.repository.RoleRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class RoleServiceImpl implements RoleService{
    private final RoleRepository roleRepository;
    @Override
    public List<RoleView> getAllRoles() {
        return roleRepository.findAll().stream().filter(r -> "active".equals(r.getStatus()))
                .map(r -> new RoleView(r.getId(),r.getName())).toList();
    }
}
