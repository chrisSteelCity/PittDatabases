package com.allen.backend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "cart_items", indexes = {
        @Index(name = "idx_cart_user_item", columnList = "user_id, shop_item_id")
})
public class CartItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @Column(name = "user_id", nullable = false)
    private Long userId;

    @NotNull
    @Column(name = "shop_item_id", nullable = false)
    private Long shopItemId;

    @Min(1)
    @Column(nullable = false)
    private Integer quantity = 1;

    public CartItem() { }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getShopItemId() { return shopItemId; }
    public void setShopItemId(Long shopItemId) { this.shopItemId = shopItemId; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
}
