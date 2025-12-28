package com.ecommerce.backend.dto;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrderDTO {
    @NotNull
    private List<Long> cartItemIds;

    @AssertTrue(message = "Danh sách cart item cần mua không được rỗng")
    public boolean isCartItemIdsNotEmpty() {
        return cartItemIds != null && !cartItemIds.isEmpty();
    }
}
