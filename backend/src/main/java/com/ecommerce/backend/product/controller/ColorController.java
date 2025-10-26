package com.ecommerce.backend.product.controller;
import com.ecommerce.backend.config.AppConstants;
import com.ecommerce.backend.product.dtos.ColorDTO;
import com.ecommerce.backend.product.dtos.ColorResponse;
import com.ecommerce.backend.product.dtos.SizeDTO;
import com.ecommerce.backend.product.dtos.SizeResponse;
import com.ecommerce.backend.product.service.ColorService;
import com.ecommerce.backend.product.service.SizeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class ColorController {

    private ColorService colorService;

    @GetMapping("/public/colors")
    public ResponseEntity<ColorResponse> getAllColors(
            @RequestParam(name = "pageNumber", defaultValue = AppConstants.PAGE_NUMBER, required = false) Integer pageNumber,
            @RequestParam(name = "pageSize", defaultValue = AppConstants.PAGE_SIZE, required = false) Integer pageSize,
            @RequestParam(name = "sortBy", defaultValue = AppConstants.SORT_CATEGORIES_BY, required = false) String sortBy,
            @RequestParam(name = "sortOrder", defaultValue = AppConstants.SORT_DIR, required = false) String sortOrder) {
        ColorResponse colorResponse = colorService.getAllColors(pageNumber, pageSize, sortBy, sortOrder);
        return new ResponseEntity<>(colorResponse, HttpStatus.OK);
    }

    @PostMapping("/admin/colors")
    public ResponseEntity<ColorDTO> createColor(@Valid @RequestBody ColorDTO colorDTO){
        ColorDTO color = colorService.createColor(colorDTO);
        return new ResponseEntity<>(color, HttpStatus.CREATED);
    }

    @DeleteMapping("/admin/colors/{colorId}")
    public ResponseEntity<ColorDTO> deleteColor(@PathVariable Long colorId){
        ColorDTO colorDTO = colorService.deleteColor(colorId);
        return new ResponseEntity<>(colorDTO, HttpStatus.OK);
    }


    @PutMapping("/admin/colors/{colorId}")
    public ResponseEntity<ColorDTO> updateColor(@Valid @RequestBody ColorDTO colorDTO,
                                               @PathVariable Long colorId){
        ColorDTO color = colorService.updateColor(colorDTO, colorId);
        return new ResponseEntity<>(color, HttpStatus.OK);
    }
}