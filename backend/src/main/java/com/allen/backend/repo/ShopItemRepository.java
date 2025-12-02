package com.allen.backend.repo;

import com.allen.backend.entity.ShopItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ShopItemRepository extends JpaRepository<ShopItem, Long> {
    List<ShopItem> findByStockGreaterThan(Integer stock);
    List<ShopItem> findByIsActiveTrue();
    List<ShopItem> findByIsActiveTrueAndStockGreaterThan(Integer stock);
}
