package com.allen.backend.controller;

import com.allen.backend.dto.ShopItemRequest;
import com.allen.backend.dto.ShopItemResponse;
import com.allen.backend.service.ShopService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shop")
public class ShopController {

    private final ShopService shopService;

    public ShopController(ShopService shopService) {
        this.shopService = shopService;
    }

    @GetMapping
    public ResponseEntity<List<ShopItemResponse>> getAllItems() {
        return ResponseEntity.ok(shopService.getAllItems());
    }

    // Support /api/shop/items for admin portal - must be before /{id}
    @GetMapping("/items")
    public ResponseEntity<List<ShopItemResponse>> getAllItemsAlias() {
        return ResponseEntity.ok(shopService.getAllItems());
    }

    @GetMapping("/available")
    public ResponseEntity<List<ShopItemResponse>> getAvailableItems() {
        return ResponseEntity.ok(shopService.getAvailableItems());
    }

    // This must come AFTER specific paths like /items and /available
    @GetMapping("/{id}")
    public ResponseEntity<?> getItemById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(shopService.getItemById(id));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping
    public ResponseEntity<?> createItem(@RequestBody ShopItemRequest request) {
        try {
            ShopItemResponse created = shopService.createItem(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(created);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/items")
    public ResponseEntity<?> createItemAlias(@RequestBody ShopItemRequest request) {
        try {
            ShopItemResponse created = shopService.createItem(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(created);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateItem(@PathVariable Long id, @RequestBody ShopItemRequest request) {
        try {
            ShopItemResponse updated = shopService.updateItem(id, request);
            return ResponseEntity.ok(updated);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/items/{id}")
    public ResponseEntity<?> updateItemAlias(@PathVariable Long id, @RequestBody ShopItemRequest request) {
        try {
            ShopItemResponse updated = shopService.updateItem(id, request);
            return ResponseEntity.ok(updated);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteItem(@PathVariable Long id) {
        try {
            shopService.deleteItem(id);
            return ResponseEntity.ok("Item deleted successfully");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/items/{id}")
    public ResponseEntity<?> deleteItemAlias(@PathVariable Long id) {
        try {
            shopService.deleteItem(id);
            return ResponseEntity.ok("Item deleted successfully");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
