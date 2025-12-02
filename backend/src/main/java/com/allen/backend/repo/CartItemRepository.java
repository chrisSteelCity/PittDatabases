package com.allen.backend.repo;

import com.allen.backend.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByUserId(Long userId);
    Optional<CartItem> findByUserIdAndShopItemId(Long userId, Long shopItemId);
    void deleteByUserId(Long userId);
}
