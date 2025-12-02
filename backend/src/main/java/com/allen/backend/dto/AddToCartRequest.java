package com.allen.backend.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class AddToCartRequest {
    @NotNull
    private Long shopItemId;

    @Min(1)
    private Integer quantity = 1;

    public AddToCartRequest() { }

    public Long getShopItemId() { return shopItemId; }
    public void setShopItemId(Long shopItemId) { this.shopItemId = shopItemId; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
}
