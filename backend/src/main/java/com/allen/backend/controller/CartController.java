package com.allen.backend.controller;

import com.allen.backend.dto.AddToCartRequest;
import com.allen.backend.dto.CartItemResponse;
import com.allen.backend.service.CartService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping("/{userId}")
    public ResponseEntity<List<CartItemResponse>> getCartItems(@PathVariable Long userId) {
        return ResponseEntity.ok(cartService.getCartItems(userId));
    }

    @PostMapping("/{userId}")
    public ResponseEntity<?> addToCart(@PathVariable Long userId, @Valid @RequestBody AddToCartRequest request) {
        try {
            return ResponseEntity.ok(cartService.addToCart(userId, request));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{userId}/{cartItemId}")
    public ResponseEntity<?> updateQuantity(@PathVariable Long userId, @PathVariable Long cartItemId,
                                            @RequestBody Map<String, Integer> body) {
        try {
            Integer quantity = body.get("quantity");
            CartItemResponse response = cartService.updateQuantity(userId, cartItemId, quantity);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/{userId}/{cartItemId}")
    public ResponseEntity<?> removeFromCart(@PathVariable Long userId, @PathVariable Long cartItemId) {
        try {
            cartService.removeFromCart(userId, cartItemId);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<?> clearCart(@PathVariable Long userId) {
        cartService.clearCart(userId);
        return ResponseEntity.noContent().build();
    }
}
