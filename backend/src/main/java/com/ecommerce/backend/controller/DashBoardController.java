package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.view.DashBoardView;
import com.ecommerce.backend.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashBoardController {
    private final DashboardService dashboardService;
    @GetMapping
    public ResponseEntity<DashBoardView> boardView(){
        return ResponseEntity.ok(dashboardService.getInit());
    }
}
