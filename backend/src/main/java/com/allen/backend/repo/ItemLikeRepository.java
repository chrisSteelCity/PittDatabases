package com.allen.backend.repo;

import com.allen.backend.entity.ItemLike;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ItemLikeRepository extends JpaRepository<ItemLike, Long> {
    Optional<ItemLike> findByUserIdAndShopItemId(Long userId, Long shopItemId);
    boolean existsByUserIdAndShopItemId(Long userId, Long shopItemId);
    int countByShopItemId(Long shopItemId);
    void deleteByUserIdAndShopItemId(Long userId, Long shopItemId);
}
