package com.ecommerce.backend.dto;

import com.ecommerce.backend.model.User;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO {
    @NotNull(message = "username không được rỗng")
    @Size(max = 254, min = 6, message = "Độ dài của username phải từ 6 đến 254 ký tự")
    private String username;
    @NotNull(message = "password không được rỗng")
    @Size(min = 8, message = "Độ dài tối thiểu phải là 8 ký tự")
    @Pattern(regexp = "^[^A-Z](?=.*\\d).+$", message = "Mật khẩu phải chữ cái đầu viết hoa và có chứa số")
    private String password;
    @NotNull(message = "confirm password không được rỗng")
    private String confirmPassword;
    @Email(message = "email không hợp lệ")
    private String email;
    @AssertTrue(message = "password và confirm password phải trùng nhau")
    private boolean hasEqualPassword(){
        return password.equals(confirmPassword);
    }
    public User toUser(){
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        User u = new User();
        u.setEmail(this.email);
        u.setUsername(this.username);
        u.setPassword(passwordEncoder.encode(this.password));
        return u;
    }
}
