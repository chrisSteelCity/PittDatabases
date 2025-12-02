package com.allen.backend.service;

import com.allen.backend.dto.ReviewResponse;
import com.allen.backend.entity.ItemReview;
import com.allen.backend.entity.ItemLike;
import com.allen.backend.entity.User;
import com.allen.backend.repo.ItemReviewRepository;
import com.allen.backend.repo.ItemLikeRepository;
import com.allen.backend.repo.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ItemInteractionService {

    private final ItemLikeRepository itemLikeRepository;
    private final ItemReviewRepository itemReviewRepository;
    private final UserRepository userRepository;

    public ItemInteractionService(ItemLikeRepository itemLikeRepository,
                                  ItemReviewRepository itemReviewRepository,
                                  UserRepository userRepository) {
        this.itemLikeRepository = itemLikeRepository;
        this.itemReviewRepository = itemReviewRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public boolean toggleLike(Long userId, Long shopItemId) {
        boolean exists = itemLikeRepository.existsByUserIdAndShopItemId(userId, shopItemId);

        if (exists) {
            // Unlike: delete the like
            itemLikeRepository.deleteByUserIdAndShopItemId(userId, shopItemId);
            return false; // unliked
        } else {
            // Like: create new like
            ItemLike like = new ItemLike(shopItemId, userId);
            itemLikeRepository.save(like);
            return true; // liked
        }
    }

    public boolean isLiked(Long userId, Long shopItemId) {
        return itemLikeRepository.existsByUserIdAndShopItemId(userId, shopItemId);
    }

    public int getLikeCount(Long shopItemId) {
        return itemLikeRepository.countByShopItemId(shopItemId);
    }

    @Transactional
    public ReviewResponse addReview(Long userId, Long shopItemId, String reviewText) {
        // Fetch the user to get the username
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));

        // Create and save the review
        ItemReview review = new ItemReview(shopItemId, userId, reviewText, user.getUsername());
        ItemReview savedReview = itemReviewRepository.save(review);

        // Convert to response DTO
        return new ReviewResponse(
                savedReview.getId(),
                savedReview.getShopItemId(),
                savedReview.getUserId(),
                savedReview.getUserName(),
                savedReview.getReviewText(),
                savedReview.getCreatedAt()
        );
    }

    public List<ReviewResponse> getReviews(Long shopItemId) {
        List<ItemReview> reviews = itemReviewRepository.findByShopItemIdOrderByCreatedAtDesc(shopItemId);

        return reviews.stream()
                .map(review -> new ReviewResponse(
                        review.getId(),
                        review.getShopItemId(),
                        review.getUserId(),
                        review.getUserName(),
                        review.getReviewText(),
                        review.getCreatedAt()
                ))
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteReview(Long reviewId) {
        ItemReview review = itemReviewRepository.findById(reviewId)
                .orElseThrow(() -> new RuntimeException("Review not found with id: " + reviewId));
        itemReviewRepository.delete(review);
    }
}
