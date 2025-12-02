package com.allen.backend.repo;

import com.allen.backend.entity.ItemReview;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ItemReviewRepository extends JpaRepository<ItemReview, Long> {
    List<ItemReview> findByShopItemIdOrderByCreatedAtDesc(Long shopItemId);
}
