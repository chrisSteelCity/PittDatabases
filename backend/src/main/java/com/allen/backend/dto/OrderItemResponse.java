package com.allen.backend.dto;

public class OrderItemResponse {
    private Long id;
    private Long shopItemId;
    private String shopItemName;
    private Integer quantity;
    private Integer pointsPerItem;

    public OrderItemResponse() { }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getShopItemId() { return shopItemId; }
    public void setShopItemId(Long shopItemId) { this.shopItemId = shopItemId; }

    public String getShopItemName() { return shopItemName; }
    public void setShopItemName(String shopItemName) { this.shopItemName = shopItemName; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public Integer getPointsPerItem() { return pointsPerItem; }
    public void setPointsPerItem(Integer pointsPerItem) { this.pointsPerItem = pointsPerItem; }
}
