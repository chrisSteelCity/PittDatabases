package com.allen.backend.service;

import com.allen.backend.dto.OrderItemResponse;
import com.allen.backend.dto.OrderResponse;
import com.allen.backend.entity.*;
import com.allen.backend.repo.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final CartItemRepository cartItemRepository;
    private final ShopItemRepository shopItemRepository;
    private final UserRepository userRepository;

    public OrderService(OrderRepository orderRepository, OrderItemRepository orderItemRepository,
                        CartItemRepository cartItemRepository, ShopItemRepository shopItemRepository,
                        UserRepository userRepository) {
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
        this.cartItemRepository = cartItemRepository;
        this.shopItemRepository = shopItemRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public OrderResponse createOrder(Long userId, String shippingAddress) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        List<CartItem> cartItems = cartItemRepository.findByUserId(userId);
        if (cartItems.isEmpty()) {
            throw new IllegalArgumentException("Cart is empty");
        }

        int totalPoints = 0;
        for (CartItem cartItem : cartItems) {
            ShopItem shopItem = shopItemRepository.findById(cartItem.getShopItemId())
                    .orElseThrow(() -> new IllegalArgumentException("Shop item not found"));

            if (shopItem.getStock() < cartItem.getQuantity()) {
                throw new IllegalArgumentException("Insufficient stock for " + shopItem.getName());
            }

            totalPoints += shopItem.getPointsRequired() * cartItem.getQuantity();
        }

        if (user.getPoints() < totalPoints) {
            throw new IllegalArgumentException("Insufficient points. Required: " + totalPoints + ", Available: " + user.getPoints());
        }

        Order order = new Order();
        order.setUserId(userId);
        order.setTotalPoints(totalPoints);
        order.setShippingAddress(shippingAddress != null ? shippingAddress : user.getAddress());
        order.setStatus(Order.OrderStatus.PENDING);
        order.setCreatedAt(ZonedDateTime.now());
        order = orderRepository.save(order);

        for (CartItem cartItem : cartItems) {
            ShopItem shopItem = shopItemRepository.findById(cartItem.getShopItemId()).get();

            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(order.getId());
            orderItem.setShopItemId(shopItem.getId());
            orderItem.setShopItemName(shopItem.getName());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPointsPerItem(shopItem.getPointsRequired());
            orderItemRepository.save(orderItem);

            shopItem.setStock(shopItem.getStock() - cartItem.getQuantity());
            shopItemRepository.save(shopItem);
        }

        user.setPoints(user.getPoints() - totalPoints);
        userRepository.save(user);

        cartItemRepository.deleteByUserId(userId);

        return getOrderById(order.getId());
    }

    @Transactional(readOnly = true)
    public OrderResponse getOrderById(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found"));

        List<OrderItem> orderItems = orderItemRepository.findByOrderId(orderId);

        OrderResponse response = new OrderResponse();
        response.setId(order.getId());
        response.setUserId(order.getUserId());
        response.setTotalPoints(order.getTotalPoints());
        response.setShippingAddress(order.getShippingAddress());
        response.setStatus(order.getStatus().name());
        response.setCreatedAt(order.getCreatedAt());
        response.setItems(orderItems.stream().map(this::toOrderItemResponse).collect(Collectors.toList()));

        return response;
    }

    @Transactional(readOnly = true)
    public List<OrderResponse> getUserOrders(Long userId) {
        List<Order> orders = orderRepository.findByUserIdOrderByCreatedAtDesc(userId);
        return orders.stream()
                .map(order -> {
                    List<OrderItem> orderItems = orderItemRepository.findByOrderId(order.getId());
                    OrderResponse response = new OrderResponse();
                    response.setId(order.getId());
                    response.setUserId(order.getUserId());
                    response.setTotalPoints(order.getTotalPoints());
                    response.setShippingAddress(order.getShippingAddress());
                    response.setStatus(order.getStatus().name());
                    response.setCreatedAt(order.getCreatedAt());
                    response.setItems(orderItems.stream().map(this::toOrderItemResponse).collect(Collectors.toList()));
                    return response;
                })
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<OrderResponse> getAllOrders() {
        List<Order> orders = orderRepository.findAll();
        return orders.stream()
                .map(order -> {
                    List<OrderItem> orderItems = orderItemRepository.findByOrderId(order.getId());
                    OrderResponse response = new OrderResponse();
                    response.setId(order.getId());
                    response.setUserId(order.getUserId());
                    response.setTotalPoints(order.getTotalPoints());
                    response.setShippingAddress(order.getShippingAddress());
                    response.setStatus(order.getStatus().name());
                    response.setCreatedAt(order.getCreatedAt());
                    response.setItems(orderItems.stream().map(this::toOrderItemResponse).collect(Collectors.toList()));
                    return response;
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public OrderResponse updateOrder(Long orderId, java.util.Map<String, Object> updates) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found"));

        if (updates.containsKey("status")) {
            String statusStr = (String) updates.get("status");
            order.setStatus(Order.OrderStatus.valueOf(statusStr));
        }

        if (updates.containsKey("shippingAddress")) {
            order.setShippingAddress((String) updates.get("shippingAddress"));
        }

        orderRepository.save(order);
        return getOrderById(orderId);
    }

    @Transactional
    public void deleteOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found"));

        // Delete associated order items first
        orderItemRepository.deleteByOrderId(orderId);

        // Delete the order
        orderRepository.delete(order);
    }

    @Transactional
    public OrderResponse cancelOrder(Long orderId, Long userId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found"));

        // Verify the order belongs to the user
        if (!order.getUserId().equals(userId)) {
            throw new IllegalArgumentException("Order does not belong to this user");
        }

        // Check if order can be cancelled (only PENDING or PROCESSING)
        if (order.getStatus() != Order.OrderStatus.PENDING &&
            order.getStatus() != Order.OrderStatus.PROCESSING) {
            throw new IllegalArgumentException("Order cannot be cancelled. Current status: " + order.getStatus());
        }

        // Get order items to restore stock
        List<OrderItem> orderItems = orderItemRepository.findByOrderId(orderId);

        // Restore stock for each item
        for (OrderItem orderItem : orderItems) {
            ShopItem shopItem = shopItemRepository.findById(orderItem.getShopItemId())
                    .orElseThrow(() -> new IllegalArgumentException("Shop item not found"));
            shopItem.setStock(shopItem.getStock() + orderItem.getQuantity());
            shopItemRepository.save(shopItem);
        }

        // Refund points to user
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        user.setPoints(user.getPoints() + order.getTotalPoints());
        userRepository.save(user);

        // Update order status to CANCELLED
        order.setStatus(Order.OrderStatus.CANCELLED);
        orderRepository.save(order);

        return getOrderById(orderId);
    }

    private OrderItemResponse toOrderItemResponse(OrderItem item) {
        OrderItemResponse response = new OrderItemResponse();
        response.setId(item.getId());
        response.setShopItemId(item.getShopItemId());
        response.setShopItemName(item.getShopItemName());
        response.setQuantity(item.getQuantity());
        response.setPointsPerItem(item.getPointsPerItem());
        return response;
    }
}
