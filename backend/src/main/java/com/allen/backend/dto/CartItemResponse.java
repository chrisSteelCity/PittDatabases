package com.allen.backend.dto;

public class CartItemResponse {
    private Long id;
    private Long shopItemId;
    private String shopItemName;
    private Integer pointsRequired;
    private Integer quantity;
    private String imageUrl;

    public CartItemResponse() { }

    public CartItemResponse(Long id, Long shopItemId, String shopItemName, Integer pointsRequired, Integer quantity, String imageUrl) {
        this.id = id;
        this.shopItemId = shopItemId;
        this.shopItemName = shopItemName;
        this.pointsRequired = pointsRequired;
        this.quantity = quantity;
        this.imageUrl = imageUrl;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getShopItemId() { return shopItemId; }
    public void setShopItemId(Long shopItemId) { this.shopItemId = shopItemId; }

    public String getShopItemName() { return shopItemName; }
    public void setShopItemName(String shopItemName) { this.shopItemName = shopItemName; }

    public Integer getPointsRequired() { return pointsRequired; }
    public void setPointsRequired(Integer pointsRequired) { this.pointsRequired = pointsRequired; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
