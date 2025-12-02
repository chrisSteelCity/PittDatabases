package com.allen.backend.controller;

import com.allen.backend.dto.ReviewResponse;
import com.allen.backend.service.ItemInteractionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/items")
public class ItemInteractionController {

    private final ItemInteractionService itemInteractionService;

    public ItemInteractionController(ItemInteractionService itemInteractionService) {
        this.itemInteractionService = itemInteractionService;
    }

    @PostMapping("/{itemId}/like")
    public ResponseEntity<?> toggleLike(@PathVariable Long itemId, @RequestBody Map<String, Long> body) {
        try {
            Long userId = body.get("userId");
            if (userId == null) {
                return ResponseEntity.badRequest().body("userId is required");
            }

            boolean liked = itemInteractionService.toggleLike(userId, itemId);

            Map<String, Object> response = new HashMap<>();
            response.put("liked", liked);
            response.put("message", liked ? "Item liked successfully" : "Item unliked successfully");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/{itemId}/like/status")
    public ResponseEntity<?> getLikeStatus(@PathVariable Long itemId, @RequestParam Long userId) {
        try {
            boolean liked = itemInteractionService.isLiked(userId, itemId);

            Map<String, Boolean> response = new HashMap<>();
            response.put("liked", liked);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/{itemId}/like/count")
    public ResponseEntity<?> getLikeCount(@PathVariable Long itemId) {
        try {
            int count = itemInteractionService.getLikeCount(itemId);

            Map<String, Integer> response = new HashMap<>();
            response.put("count", count);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/{itemId}/reviews")
    public ResponseEntity<?> addReview(@PathVariable Long itemId, @RequestBody Map<String, Object> body) {
        try {
            Long userId = body.get("userId") != null ? ((Number) body.get("userId")).longValue() : null;
            String reviewText = (String) body.get("reviewText");

            if (userId == null) {
                return ResponseEntity.badRequest().body("userId is required");
            }
            if (reviewText == null || reviewText.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("reviewText is required");
            }

            ReviewResponse review = itemInteractionService.addReview(userId, itemId, reviewText);
            return ResponseEntity.ok(review);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error adding review: " + e.getMessage());
        }
    }

    @GetMapping("/{itemId}/reviews")
    public ResponseEntity<?> getReviews(@PathVariable Long itemId) {
        try {
            List<ReviewResponse> reviews = itemInteractionService.getReviews(itemId);
            return ResponseEntity.ok(reviews);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/reviews/{reviewId}")
    public ResponseEntity<?> deleteReview(@PathVariable Long reviewId) {
        try {
            itemInteractionService.deleteReview(reviewId);
            return ResponseEntity.ok("Review deleted successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error deleting review: " + e.getMessage());
        }
    }
}
