package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.view.RoleView;
import com.ecommerce.backend.service.RoleService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/roles")
@AllArgsConstructor
public class RoleController {
    private final RoleService roleService;
    @GetMapping
    public ResponseEntity<List<RoleView>> getAllRoles(){
        var res = roleService.getAllRoles();
        if(res.isEmpty())
            return ResponseEntity.badRequest().build();
        return ResponseEntity.ok(res);
    }
}
