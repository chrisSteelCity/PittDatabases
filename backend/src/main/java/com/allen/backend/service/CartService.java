package com.allen.backend.service;

import com.allen.backend.dto.AddToCartRequest;
import com.allen.backend.dto.CartItemResponse;
import com.allen.backend.entity.CartItem;
import com.allen.backend.entity.ShopItem;
import com.allen.backend.repo.CartItemRepository;
import com.allen.backend.repo.ShopItemRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CartService {

    private final CartItemRepository cartItemRepository;
    private final ShopItemRepository shopItemRepository;

    public CartService(CartItemRepository cartItemRepository, ShopItemRepository shopItemRepository) {
        this.cartItemRepository = cartItemRepository;
        this.shopItemRepository = shopItemRepository;
    }

    @Transactional(readOnly = true)
    public List<CartItemResponse> getCartItems(Long userId) {
        List<CartItem> cartItems = cartItemRepository.findByUserId(userId);
        return cartItems.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public CartItemResponse addToCart(Long userId, AddToCartRequest request) {
        ShopItem shopItem = shopItemRepository.findById(request.getShopItemId())
                .orElseThrow(() -> new IllegalArgumentException("Shop item not found"));

        if (shopItem.getStock() < request.getQuantity()) {
            throw new IllegalArgumentException("Insufficient stock");
        }

        CartItem cartItem = cartItemRepository.findByUserIdAndShopItemId(userId, request.getShopItemId())
                .orElse(new CartItem());

        if (cartItem.getId() == null) {
            cartItem.setUserId(userId);
            cartItem.setShopItemId(request.getShopItemId());
            cartItem.setQuantity(request.getQuantity());
        } else {
            cartItem.setQuantity(cartItem.getQuantity() + request.getQuantity());
        }

        cartItem = cartItemRepository.save(cartItem);
        return toResponse(cartItem);
    }

    @Transactional
    public CartItemResponse updateQuantity(Long userId, Long cartItemId, Integer quantity) {
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new IllegalArgumentException("Cart item not found"));

        if (!cartItem.getUserId().equals(userId)) {
            throw new IllegalArgumentException("Unauthorized");
        }

        if (quantity <= 0) {
            cartItemRepository.delete(cartItem);
            return null;
        }

        ShopItem shopItem = shopItemRepository.findById(cartItem.getShopItemId())
                .orElseThrow(() -> new IllegalArgumentException("Shop item not found"));

        if (shopItem.getStock() < quantity) {
            throw new IllegalArgumentException("Insufficient stock");
        }

        cartItem.setQuantity(quantity);
        cartItem = cartItemRepository.save(cartItem);
        return toResponse(cartItem);
    }

    @Transactional
    public void removeFromCart(Long userId, Long cartItemId) {
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new IllegalArgumentException("Cart item not found"));

        if (!cartItem.getUserId().equals(userId)) {
            throw new IllegalArgumentException("Unauthorized");
        }

        cartItemRepository.delete(cartItem);
    }

    @Transactional
    public void clearCart(Long userId) {
        cartItemRepository.deleteByUserId(userId);
    }

    private CartItemResponse toResponse(CartItem cartItem) {
        ShopItem shopItem = shopItemRepository.findById(cartItem.getShopItemId()).orElse(null);
        if (shopItem == null) {
            return null;
        }
        return new CartItemResponse(
                cartItem.getId(),
                shopItem.getId(),
                shopItem.getName(),
                shopItem.getPointsRequired(),
                cartItem.getQuantity(),
                shopItem.getImageUrl()
        );
    }
}
