package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.UserDTO;
import com.ecommerce.backend.dto.UserUpdateDTO;
import com.ecommerce.backend.dto.view.UserSearch;
import com.ecommerce.backend.dto.view.UserDetailView;
import com.ecommerce.backend.dto.view.UserItemView;
import com.ecommerce.backend.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.management.BadAttributeValueExpException;
import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @GetMapping
    public ResponseEntity<Page<UserItemView>> getAllUsers(Pageable pageable) {
        return ResponseEntity.ok(userService.getAllUsers(pageable));
    }

    @PostMapping
    public ResponseEntity<Void> createUser(@RequestBody @Valid UserDTO userDTO, BindingResult bindingResult) throws BadAttributeValueExpException { // Changed parameter to UserDTO
        if(bindingResult.hasErrors()){
            throw new RuntimeException(bindingResult.getAllErrors().get(0).getDefaultMessage());
        }
        userService.createUser(userDTO);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Void> updateUser(@PathVariable Long id, @RequestBody @Valid UserUpdateDTO userUpdateDTO, BindingResult bindingResult) throws BadAttributeValueExpException { // Changed parameter to UserDTO
        if(bindingResult.hasErrors()){
            throw new RuntimeException(bindingResult.getAllErrors().get(0).getDefaultMessage());
        }
        var user = userService.updateUser(id,userUpdateDTO);
        if(user == null)
            return ResponseEntity.badRequest().build();
        return ResponseEntity.status(HttpStatus.OK).build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
    @GetMapping("/detail/{id}")
    public ResponseEntity<UserDetailView> getDetail(@PathVariable("id") long id){
        return ResponseEntity.ok(userService.searchById(id));
    }

    @GetMapping("/search")
    public ResponseEntity<List<UserSearch>> searchUserByName(@RequestParam(value = "name") String name){
        return ResponseEntity.ok(userService.searchByName(name));
    }
    @GetMapping("/update/{id}")
    public ResponseEntity<UserUpdateDTO> getUpdateInfo(@PathVariable("id") long id){
        var res = userService.searchById(id);
        return ResponseEntity.ok(new UserUpdateDTO(res.getName(),res.getEmail(),res.getBirthDay()));
    }
}
