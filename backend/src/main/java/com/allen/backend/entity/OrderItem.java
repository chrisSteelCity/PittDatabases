package com.allen.backend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "order_items", indexes = {
        @Index(name = "idx_order_items_order", columnList = "order_id")
})
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @Column(name = "order_id", nullable = false)
    private Long orderId;

    @NotNull
    @Column(name = "shop_item_id", nullable = false)
    private Long shopItemId;

    @Column(name = "shop_item_name", nullable = false, length = 100)
    private String shopItemName;

    @Min(1)
    @Column(nullable = false)
    private Integer quantity;

    @Min(0)
    @Column(name = "points_per_item", nullable = false)
    private Integer pointsPerItem;

    public OrderItem() { }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public Long getShopItemId() { return shopItemId; }
    public void setShopItemId(Long shopItemId) { this.shopItemId = shopItemId; }

    public String getShopItemName() { return shopItemName; }
    public void setShopItemName(String shopItemName) { this.shopItemName = shopItemName; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public Integer getPointsPerItem() { return pointsPerItem; }
    public void setPointsPerItem(Integer pointsPerItem) { this.pointsPerItem = pointsPerItem; }
}
