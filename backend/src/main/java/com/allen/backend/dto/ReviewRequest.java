package com.allen.backend.dto;

public class ReviewRequest {
    private String reviewText;

    public ReviewRequest() {}

    public ReviewRequest(String reviewText) {
        this.reviewText = reviewText;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }
}
