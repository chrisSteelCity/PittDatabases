-- ============================================
-- Initialize Shop Data (English Version)
-- ============================================

-- Disable foreign keys so we can reset the table
SET FOREIGN_KEY_CHECKS = 0;

-- Recreate table (safe even with FK dependencies)
DROP TABLE IF EXISTS shop_items;

CREATE TABLE shop_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    points_required INT NOT NULL,
    image_url VARCHAR(255),
    stock INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT check_points_positive CHECK (points_required >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- Insert fitness shop items (English)
INSERT INTO shop_items (name, description, points_required, image_url, stock) VALUES
-- Protection Gear Series
('Professional Wrist Wraps', 'Compression wrist wraps, elastic and breathable, suitable for weightlifting, provides wrist support', 280, 'https://images.unsplash.com/photo-1611672585731-fa10603fb9e0?w=400&h=300&fit=crop', 150),
('Weightlifting Belt', 'Wide and thick lifting belt, protects lower back, essential for squats and deadlifts, adjustable size', 350, 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?w=400&h=300&fit=crop', 80),
('Knee Sleeves', 'Sports knee sleeves pair, for basketball running fitness, anti-slip breathable compression protection', 300, 'https://images.unsplash.com/photo-1606889464198-fcb18894cf50?w=400&h=300&fit=crop', 100),
('Elbow Support Sleeves', 'Weightlifting elbow sleeves, elastic compression, protects elbow joints, comes in pairs', 290, 'https://images.unsplash.com/photo-1599058918394-8dc3f8b6e04e?w=400&h=300&fit=crop', 90),

-- Fitness Equipment Series
('Resistance Bands Set', '5-piece fitness resistance bands, different resistance levels, includes door anchor and storage bag', 320, 'https://images.unsplash.com/photo-1598289431512-b97b0917affc?w=400&h=300&fit=crop', 70),
('Extra Thick Yoga Mat', '10mm thick NBR yoga mat, eco-friendly material, 185cm extra long, includes carrying strap', 340, 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=400&h=300&fit=crop', 85),
('Professional Jump Rope', 'Adjustable bearing jump rope, anti-slip handle, counting function, suitable for fat loss training', 260, 'https://images.unsplash.com/photo-1598970434795-0c54fe7c0648?w=400&h=300&fit=crop', 120),
('Home Fitness Dumbbells', 'Eco-friendly coated dumbbells, 2-piece set, 3kg/5kg/8kg options, anti-slip and drop-resistant', 380, 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=400&h=300&fit=crop', 60),

-- Sports Accessories Series
('Smart Fitness Tracker', 'Heart rate monitoring sleep tracking, 50m waterproof, 7-day battery life, rich sports modes', 400, 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=400&h=300&fit=crop', 50),
('Premium Sports Water Bottle', 'Stainless steel insulated sports bottle, 750ml large capacity, 12-hour insulation, leak-proof design', 300, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&h=300&fit=crop', 100),
('Large Capacity Sports Backpack', '30L gym bag, wet and dry separation, independent shoe compartment, USB charging port, waterproof fabric', 330, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=300&fit=crop', 65),
('Quick-Dry Sports Towel', 'Microfiber sports towel 2-pack, quick-dry antibacterial, soft and absorbent, includes storage bag', 270, 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=400&h=300&fit=crop', 130),

-- Nutrition Supplements Series
('Whey Protein Powder', 'High-quality isolated whey protein, vanilla flavor 2lbs, essential for muscle building, easily soluble', 390, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=400&h=300&fit=crop', 45),
('BCAA Amino Acids', 'Pre/during/post workout supplement, reduces muscle breakdown, speeds recovery, lemon flavor', 360, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=400&h=300&fit=crop', 55),
('Creatine Powder Supplement', 'Pure creatine monohydrate, 300g pack, enhances explosive power and endurance', 310, 'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=400&h=300&fit=crop', 70),

-- Sports Apparel Series
('Professional Fitness Gloves', 'Half-finger anti-slip fitness gloves, breathable wrist protection, suitable for weightlifting pull-ups', 285, 'https://images.unsplash.com/photo-1598289431512-b97b0917affc?w=400&h=300&fit=crop', 95),
('Compression Athletic Shirt', 'Quick-dry breathable compression top, tight fit design, reduces muscle vibration, enhances performance', 340, 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400&h=300&fit=crop', 75),
('Running Phone Armband', 'Waterproof reflective running armband, fits phones under 6.5 inches, touchscreen compatible', 280, 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&h=300&fit=crop', 110),
('Professional Sports Socks', 'Mid-calf sports socks 3-pack, towel bottom cushioning, antibacterial odor-resistant, good elasticity', 250, 'https://images.unsplash.com/photo-1586350977771-b3b0abd50c82?w=400&h=300&fit=crop', 140),

-- Recovery Training Series
('Foam Roller for Muscle Release', '45cm high-density foam roller, muscle relaxation massage, includes usage tutorial', 295, 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?w=400&h=300&fit=crop', 80);

-- View inserted items
SELECT * FROM shop_items ORDER BY points_required;

-- View items by price range
SELECT
    CASE
        WHEN points_required < 300 THEN '250-299 Points'
        WHEN points_required < 350 THEN '300-349 Points'
        WHEN points_required < 400 THEN '350-399 Points'
        ELSE '400+ Points'
    END AS price_range,
    COUNT(*) AS item_count,
    SUM(stock) AS total_stock
FROM shop_items
GROUP BY price_range
ORDER BY MIN(points_required);
