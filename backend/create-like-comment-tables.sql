-- Create item_likes table
CREATE TABLE IF NOT EXISTS item_likes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    shop_item_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (shop_item_id) REFERENCES shop_items(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_item_like (user_id, shop_item_id)
);

-- Create item_reviews table (renamed from item_comments)
CREATE TABLE IF NOT EXISTS item_reviews (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    shop_item_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    user_name VARCHAR(32) NOT NULL,
    review_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (shop_item_id) REFERENCES shop_items(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);



-- Insert sample likes (user 29 likes items 1, 2, 3)
INSERT INTO item_likes (shop_item_id, user_id) VALUES
(1, 29),
(2, 29),
(3, 29),
(1, 1),
(1, 2),
(2, 1);

-- Insert sample reviews (renamed from comments)
INSERT INTO item_reviews (shop_item_id, user_id, user_name, review_text) VALUES
(1, 29, 'User29', 'Great product! Very comfortable and durable.'),
(1, 1, 'User1', 'Perfect for heavy lifting, highly recommend!'),
(2, 29, 'User29', 'Excellent support for my lower back during squats.'),
(2, 2, 'User2', 'Best weightlifting belt I have ever used!'),
(3, 29, 'User29', 'These knee sleeves are amazing for running and basketball.'),
(1, 2, 'User2', 'Good quality, worth the points!');
