package com.allen.backend.service;

import com.allen.backend.dto.ShopItemRequest;
import com.allen.backend.dto.ShopItemResponse;
import com.allen.backend.entity.ShopItem;
import com.allen.backend.repo.ShopItemRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ShopService {

    private final ShopItemRepository shopItemRepository;

    public ShopService(ShopItemRepository shopItemRepository) {
        this.shopItemRepository = shopItemRepository;
    }

    public List<ShopItemResponse> getAllItems() {
        return shopItemRepository.findAll().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public List<ShopItemResponse> getAvailableItems() {
        // Only return active items with stock > 0
        return shopItemRepository.findByIsActiveTrueAndStockGreaterThan(0).stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public ShopItemResponse getItemById(Long id) {
        ShopItem item = shopItemRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Shop item not found"));
        return toResponse(item);
    }

    @Transactional
    public ShopItemResponse createItem(ShopItemRequest request) {
        ShopItem item = new ShopItem();
        item.setName(request.getName());
        item.setDescription(request.getDescription());
        item.setPointsRequired(request.getPointsRequired());
        item.setImageUrl(request.getImageUrl());
        item.setStock(request.getStock());
        item.setIsActive(request.getIsActive());

        ShopItem saved = shopItemRepository.save(item);
        return toResponse(saved);
    }

    @Transactional
    public ShopItemResponse updateItem(Long id, ShopItemRequest request) {
        ShopItem item = shopItemRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Shop item not found"));

        item.setName(request.getName());
        item.setDescription(request.getDescription());
        item.setPointsRequired(request.getPointsRequired());
        item.setImageUrl(request.getImageUrl());
        item.setStock(request.getStock());
        item.setIsActive(request.getIsActive());

        ShopItem updated = shopItemRepository.save(item);
        return toResponse(updated);
    }

    @Transactional
    public void deleteItem(Long id) {
        ShopItem item = shopItemRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Shop item not found"));

        // Soft delete: set isActive to false instead of physically deleting
        item.setIsActive(false);
        shopItemRepository.save(item);
    }

    private ShopItemResponse toResponse(ShopItem item) {
        return new ShopItemResponse(
                item.getId(),
                item.getName(),
                item.getDescription(),
                item.getPointsRequired(),
                item.getImageUrl(),
                item.getStock(),
                item.getIsActive()
        );
    }
}
