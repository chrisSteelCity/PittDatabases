package com.allen.backend.dto;

import java.time.LocalDateTime;

public class ReviewResponse {
    private Long id;
    private Long shopItemId;
    private Long userId;
    private String userName;
    private String reviewText;
    private LocalDateTime createdAt;

    public ReviewResponse() {}

    public ReviewResponse(Long id, Long shopItemId, Long userId, String userName, String reviewText, LocalDateTime createdAt) {
        this.id = id;
        this.shopItemId = shopItemId;
        this.userId = userId;
        this.userName = userName;
        this.reviewText = reviewText;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
