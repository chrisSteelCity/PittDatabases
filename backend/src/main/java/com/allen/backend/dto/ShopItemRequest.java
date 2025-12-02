package com.allen.backend.dto;

public class ShopItemRequest {
    private String name;
    private String description;
    private Integer pointsRequired;
    private String imageUrl;
    private Integer stock;
    private Boolean isActive;

    public ShopItemRequest() {
    }

    public ShopItemRequest(String name, String description, Integer pointsRequired, String imageUrl, Integer stock, Boolean isActive) {
        this.name = name;
        this.description = description;
        this.pointsRequired = pointsRequired;
        this.imageUrl = imageUrl;
        this.stock = stock;
        this.isActive = isActive;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getPointsRequired() {
        return pointsRequired;
    }

    public void setPointsRequired(Integer pointsRequired) {
        this.pointsRequired = pointsRequired;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}
