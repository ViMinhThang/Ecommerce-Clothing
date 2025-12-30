package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.view.RoleView;

import java.util.List;

public interface RoleService {
    List<RoleView> getAllRoles();
}
