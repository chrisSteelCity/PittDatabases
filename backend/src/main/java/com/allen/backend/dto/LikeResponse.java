package com.allen.backend.dto;

import java.time.LocalDateTime;

public class LikeResponse {
    private Long shopItemId;
    private Long userId;
    private LocalDateTime createdAt;

    public LikeResponse() {}

    public LikeResponse(Long shopItemId, Long userId, LocalDateTime createdAt) {
        this.shopItemId = shopItemId;
        this.userId = userId;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Long getShopItemId() {
        return shopItemId;
    }

    public void setShopItemId(Long shopItemId) {
        this.shopItemId = shopItemId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
