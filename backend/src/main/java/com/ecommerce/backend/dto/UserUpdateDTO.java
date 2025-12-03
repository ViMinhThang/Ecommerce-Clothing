package com.ecommerce.backend.dto;

import com.ecommerce.backend.model.User;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserUpdateDTO {
    @NotNull(message = "full name không được rỗng")
    @Size(max = 100, min = 6, message = "Độ dài của full name phải từ 6 đến 100 ký tự")
    private String fullName;
    @Email(message = "email không hợp lệ")
    private String email;
    private LocalDate birthDay;
    public User updateUser(User user){
        user.setFullName(fullName);
        user.setEmail(email);
        if(birthDay != null){
            user.setBirthDay(birthDay);
        }
        return user;
    }
}
