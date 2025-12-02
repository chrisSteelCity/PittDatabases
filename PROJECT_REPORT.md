# Exercise Tracker & Points Shopping System
## Technical Project Report

---

## 1. System Overview

### System Description
The Exercise Tracker & Points Shopping System is a full-stack web application designed to promote fitness and healthy lifestyles through gamification. The system enables users to track their exercise activities, earn points through daily check-ins and workouts, and redeem those points for fitness-related products in an integrated shopping system.

### User Types and Access Levels

#### 1.1 End Users (Regular Users)
**Access:** UserPortal (Mobile Web Application)
- **Authentication:** Username/password-based registration and login with BCrypt password hashing
- **Primary Functions:**
  - Track exercise activities with timezone support (Running, Walking, Cycling, Swimming, Gym, Other)
  - View exercise history and 7-day activity charts
  - Earn points through daily check-ins (+20 points per day)
  - Browse shop items and view product details
  - Manage shopping cart
  - Place orders using earned points
  - View order history with expandable item details
  - Update shipping address
  - Track order status (PENDING → SHIPPED → DELIVERED)

#### 1.2 Administrators (Health Coaches)
**Access:** Web-Portal (Admin Dashboard)
- **Authentication:** Separate username/password authentication system
- **Primary Functions:**
  - **User Monitoring:**
    - View all registered users on dashboard
    - Monitor user exercise activity
    - Identify inactive users (>2 days without activity) with warning indicators
    - View detailed user exercise history and 7-day trend charts
  - **Shop Management (CRUD):**
    - Create new shop items with points pricing, descriptions, and images
    - Update existing product information and inventory
    - Delete products from the shop
    - Monitor real-time stock levels
  - **Order Management (CRUD):**
    - View all orders across all users
    - Update order status workflow
    - Modify shipping addresses
    - Delete orders if necessary
  - **User Management (CRUD):**
    - View all user profiles
    - Adjust user points (rewards/penalties)
    - Update user addresses
    - Delete user accounts

### System Architecture
- **Backend:** Spring Boot 3.5.7 REST API with MySQL 8.0+ database
- **Frontend (Users):** Ionic Framework 8 + Angular 20 (mobile-responsive)
- **Frontend (Admins):** Angular 20 standalone components
- **Communication:** RESTful API architecture with JSON data exchange

---

## 2. System Assumptions

### 2.1 User Behavior Assumptions
1. **Single Device Usage:** Each user primarily accesses the system from one device at a time. Concurrent multi-device access is supported but not optimized.
2. **Honest Exercise Reporting:** Users are assumed to report their exercise activities honestly. The system does not integrate with fitness trackers for automatic verification.
3. **Address Accuracy:** Users are responsible for providing accurate shipping addresses for order delivery.
4. **Point Economy:** Users cannot transfer points between accounts, ensuring the integrity of the reward system.

### 2.2 Technical Assumptions
1. **Network Connectivity:** The system assumes stable internet connectivity for real-time synchronization between frontend and backend.
2. **Browser Compatibility:** Frontend applications are optimized for modern browsers (Chrome, Firefox, Safari, Edge) with ES6+ support.
3. **Database Integrity:** MySQL enforces referential integrity through foreign key constraints, maintaining data consistency.
4. **Timezone Awareness:** Exercise records store timezone information (IANA format) to display activities correctly across different regions.
5. **BCrypt Security:** Password security relies on BCrypt hashing with default work factor (10 rounds), providing adequate protection against brute-force attacks.

### 2.3 Business Logic Assumptions
1. **Stock Management:** Product stock decreases immediately when an order is placed, not when it's shipped or delivered.
2. **Point Deduction:** Points are deducted from user accounts immediately upon order placement and are not refunded if an order is deleted by admin.
3. **Daily Check-in:** Users can check in once per day (based on server date), earning a fixed 20-point reward.
4. **Order Lifecycle:** Orders progress through states: PENDING → SHIPPED → DELIVERED. Cancelled orders exist as a status but are typically handled through deletion.
5. **Admin Authority:** Administrators have full control over the system data without requiring user consent for modifications.

### 2.4 Data Assumptions
1. **User Uniqueness:** Usernames and admin usernames are unique across their respective tables.
2. **UUID Generation:** Each user is assigned a UUID for future API extensions, though current implementation uses numeric IDs for primary operations.
3. **Exercise Duration:** All exercise durations are recorded in minutes (minimum 1 minute).
4. **Points Non-Negative:** User point balances cannot be negative; the system prevents checkout if insufficient points exist.

---

## 3. Entity-Relationship (E-R) Diagram

### 3.1 E-R Diagram

```
┌─────────────────┐
│     USERS       │
├─────────────────┤
│ PK: id          │
│     username    │
│     password    │
│     uuid        │
│     points      │
│     address     │
│     last_checkin│
└────────┬────────┘
         │
         │ 1
         │
         │ N
         │
    ┌────┴──────┐
    │           │
    │           │
┌───▼────────┐  │   ┌─────────────────┐
│ EXERCISES  │  │   │   CART_ITEMS    │
├────────────┤  │   ├─────────────────┤
│ PK: id     │  │   │ PK: id          │
│ FK: user_id│  │   │ FK: user_id     │
│    type    │  │   │ FK: shop_item_id│
│    duration│  │   │    quantity     │
│    location│  │   └────────┬────────┘
│  occurred_at  │            │
│  timezone  │               │ N
└────────────┘               │
                             │ 1
    ┌────────────────────────┘
    │
┌───▼──────────┐
│  SHOP_ITEMS  │
├──────────────┤
│ PK: id       │
│    name      │
│    description│
│  points_req  │
│  image_url   │
│    stock     │
└────┬─────────┘
     │
     │ 1
     │
     │ N
     │
┌────▼──────────┐
│ ORDER_ITEMS   │
├───────────────┤
│ PK: id        │
│ FK: order_id  │
│ FK: shop_item_id│
│    shop_name  │
│    quantity   │
│  points_per   │
└────┬──────────┘
     │
     │ N
     │
     │ 1
     │
┌────▼────────┐
│   ORDERS    │
├─────────────┤
│ PK: id      │
│ FK: user_id │
│total_points │
│ship_address │
│   status    │
│ created_at  │
└─────┬───────┘
      │
      │ N (belongs to)
      │
      │ 1
      │
┌─────▼──────────┐
│     USERS      │
└────────────────┘


┌─────────────────┐
│ HEALTH_COACHES  │
├─────────────────┤
│ PK: id          │
│    username     │
│    password     │
└─────────────────┘
    (Separate authentication system)


┌─────────────────┐          ┌──────────────────┐
│   ITEM_LIKES    │          │  ITEM_COMMENTS   │
├─────────────────┤          ├──────────────────┤
│ PK: id          │          │ PK: id           │
│ FK: user_id     │          │ FK: user_id      │
│ FK: shop_item_id│          │ FK: shop_item_id │
│    created_at   │          │ comment_text     │
└─────────────────┘          │ user_name        │
                             │ created_at       │
                             └──────────────────┘
```

### 3.2 Entity Set Descriptions

#### 3.2.1 USERS
**Description:** Stores end-user account information and points balance.
- **Attributes:**
  - `id` (PK): Unique user identifier
  - `username`: User's login name (3-32 characters, unique)
  - `passwordHash`: BCrypt-hashed password (3-100 characters)
  - `uuid`: Universally unique identifier (36 characters)
  - `points`: Current point balance (default 0, non-negative integer)
  - `address`: Shipping address (max 255 characters, nullable)
  - `lastCheckinDate`: Last daily check-in date for reward eligibility

#### 3.2.2 HEALTH_COACHES
**Description:** Stores administrator account information (separate from users).
- **Attributes:**
  - `id` (PK): Unique admin identifier
  - `username`: Admin login name (3-32 characters, unique)
  - `passwordHash`: BCrypt-hashed password (3-100 characters)

#### 3.2.3 EXERCISES
**Description:** Records individual exercise activities performed by users.
- **Attributes:**
  - `id` (PK): Unique exercise record identifier
  - `user_id` (FK): Reference to user who performed exercise
  - `type`: Exercise category (ENUM: RUN, WALK, CYCLE, SWIM, GYM, OTHER)
  - `durationMinutes`: Exercise duration in minutes (minimum 1)
  - `location`: Where exercise occurred (max 128 characters, optional)
  - `occurredAt`: Timestamp with timezone when exercise happened
  - `timezone`: IANA timezone identifier (e.g., "America/New_York")

#### 3.2.4 SHOP_ITEMS
**Description:** Catalog of fitness products available for purchase with points.
- **Attributes:**
  - `id` (PK): Unique product identifier
  - `name`: Product name (max 100 characters)
  - `description`: Product details (max 500 characters, optional)
  - `pointsRequired`: Points cost to purchase (non-negative integer)
  - `imageUrl`: URL to product image (max 255 characters, optional)
  - `stock`: Available inventory quantity (default 0)

#### 3.2.5 CART_ITEMS
**Description:** Temporary storage for items users intend to purchase.
- **Attributes:**
  - `id` (PK): Unique cart entry identifier
  - `user_id` (FK): Reference to user who owns cart
  - `shop_item_id` (FK): Reference to product in cart
  - `quantity`: Number of items (minimum 1)

#### 3.2.6 ORDERS
**Description:** Records completed purchase transactions.
- **Attributes:**
  - `id` (PK): Unique order identifier
  - `user_id` (FK): Reference to user who placed order
  - `totalPoints`: Total points spent on order
  - `shippingAddress`: Delivery address (max 255 characters)
  - `status`: Order state (ENUM: PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED)
  - `createdAt`: Timestamp when order was placed

#### 3.2.7 ORDER_ITEMS
**Description:** Line items detailing products within each order.
- **Attributes:**
  - `id` (PK): Unique order item identifier
  - `order_id` (FK): Reference to parent order
  - `shop_item_id` (FK): Reference to purchased product
  - `shopItemName`: Snapshot of product name at purchase time
  - `quantity`: Number of items purchased (minimum 1)
  - `pointsPerItem`: Price per unit at purchase time

#### 3.2.8 ITEM_LIKES
**Description:** Tracks user likes/favorites on shop items.
- **Attributes:**
  - `id` (PK): Unique like identifier
  - `user_id` (FK): Reference to user who liked
  - `shop_item_id` (FK): Reference to liked product
  - `createdAt`: Timestamp when like was created
- **Constraint:** Unique combination of (user_id, shop_item_id) prevents duplicate likes

#### 3.2.9 ITEM_COMMENTS
**Description:** Stores user comments/reviews on shop items.
- **Attributes:**
  - `id` (PK): Unique comment identifier
  - `user_id` (FK): Reference to commenting user
  - `shop_item_id` (FK): Reference to commented product
  - `commentText`: Comment content (max 1000 characters)
  - `userName`: Username snapshot at comment time (max 32 characters)
  - `createdAt`: Timestamp when comment was posted

### 3.3 Relationship Set Descriptions

#### 3.3.1 USER-EXERCISES (1:N)
**Description:** One user can perform many exercises; each exercise belongs to exactly one user.
- **Cardinality:** One-to-Many
- **Participation:** User (partial), Exercise (total)
- **Foreign Key:** exercises.user_id → users.id

#### 3.3.2 USER-CART_ITEMS (1:N)
**Description:** One user can have many items in their cart; each cart item belongs to one user.
- **Cardinality:** One-to-Many
- **Participation:** User (partial), CartItem (total)
- **Foreign Key:** cart_items.user_id → users.id

#### 3.3.3 SHOP_ITEM-CART_ITEMS (1:N)
**Description:** One product can appear in many users' carts; each cart entry references one product.
- **Cardinality:** One-to-Many
- **Participation:** ShopItem (partial), CartItem (total)
- **Foreign Key:** cart_items.shop_item_id → shop_items.id

#### 3.3.4 USER-ORDERS (1:N)
**Description:** One user can place many orders; each order belongs to one user.
- **Cardinality:** One-to-Many
- **Participation:** User (partial), Order (total)
- **Foreign Key:** orders.user_id → users.id

#### 3.3.5 ORDER-ORDER_ITEMS (1:N)
**Description:** One order contains many line items; each line item belongs to one order.
- **Cardinality:** One-to-Many
- **Participation:** Order (total), OrderItem (total)
- **Foreign Key:** order_items.order_id → orders.id
- **Cascade:** When order is deleted, all associated order_items are deleted

#### 3.3.6 SHOP_ITEM-ORDER_ITEMS (1:N)
**Description:** One product can be ordered many times; each order item references one product.
- **Cardinality:** One-to-Many
- **Participation:** ShopItem (partial), OrderItem (total)
- **Foreign Key:** order_items.shop_item_id → shop_items.id

#### 3.3.7 USER-ITEM_LIKES (1:N)
**Description:** One user can like many products; each like belongs to one user.
- **Cardinality:** One-to-Many
- **Participation:** User (partial), ItemLike (total)
- **Foreign Key:** item_likes.user_id → users.id

#### 3.3.8 SHOP_ITEM-ITEM_LIKES (1:N)
**Description:** One product can be liked by many users; each like references one product.
- **Cardinality:** One-to-Many
- **Participation:** ShopItem (partial), ItemLike (total)
- **Foreign Key:** item_likes.shop_item_id → shop_items.id

#### 3.3.9 USER-ITEM_COMMENTS (1:N)
**Description:** One user can post many comments; each comment belongs to one user.
- **Cardinality:** One-to-Many
- **Participation:** User (partial), ItemComment (total)
- **Foreign Key:** item_comments.user_id → users.id

#### 3.3.10 SHOP_ITEM-ITEM_COMMENTS (1:N)
**Description:** One product can have many comments; each comment references one product.
- **Cardinality:** One-to-Many
- **Participation:** ShopItem (partial), ItemComment (total)
- **Foreign Key:** item_comments.shop_item_id → shop_items.id

---

## 4. Relational Schema

### 4.1 Table Schemas with Keys

#### **users**
```
users(
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(32) NOT NULL UNIQUE,
  password_hash VARCHAR(100) NOT NULL,
  uuid VARCHAR(36) NOT NULL UNIQUE,
  points INT NOT NULL DEFAULT 0,
  address VARCHAR(255),
  last_checkin_date DATE
)
```
- **Primary Key:** id
- **Unique Keys:** username, uuid
- **Indexes:** PRIMARY KEY (id), UNIQUE (username), UNIQUE (uuid)

#### **health_coaches**
```
health_coaches(
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(32) NOT NULL UNIQUE,
  password_hash VARCHAR(100) NOT NULL
)
```
- **Primary Key:** id
- **Unique Key:** username
- **Indexes:** PRIMARY KEY (id), UNIQUE (username)

#### **exercises**
```
exercises(
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  type VARCHAR(24) NOT NULL,
  duration_minutes INT NOT NULL CHECK (duration_minutes >= 1),
  location VARCHAR(128),
  occurred_at TIMESTAMP NOT NULL,
  timezone VARCHAR(64),
  FOREIGN KEY (user_id) REFERENCES users(id)
)
```
- **Primary Key:** id
- **Foreign Key:** user_id → users(id)
- **Indexes:** PRIMARY KEY (id), INDEX (user_id, occurred_at)

#### **shop_items**
```
shop_items(
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(500),
  points_required INT NOT NULL CHECK (points_required >= 0),
  image_url VARCHAR(255),
  stock INT NOT NULL DEFAULT 0
)
```
- **Primary Key:** id
- **Indexes:** PRIMARY KEY (id)

#### **cart_items**
```
cart_items(
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  shop_item_id BIGINT NOT NULL,
  quantity INT NOT NULL CHECK (quantity >= 1),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (shop_item_id) REFERENCES shop_items(id)
)
```
- **Primary Key:** id
- **Foreign Keys:**
  - user_id → users(id)
  - shop_item_id → shop_items(id)
- **Indexes:** PRIMARY KEY (id), INDEX (user_id, shop_item_id)

#### **orders**
```
orders(
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  total_points INT NOT NULL,
  shipping_address VARCHAR(255),
  status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  created_at TIMESTAMP NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
)
```
- **Primary Key:** id
- **Foreign Key:** user_id → users(id)
- **Indexes:** PRIMARY KEY (id), INDEX (user_id, created_at)

#### **order_items**
```
order_items(
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  shop_item_id BIGINT NOT NULL,
  shop_item_name VARCHAR(100) NOT NULL,
  quantity INT NOT NULL CHECK (quantity >= 1),
  points_per_item INT NOT NULL CHECK (points_per_item >= 0),
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (shop_item_id) REFERENCES shop_items(id)
)
```
- **Primary Key:** id
- **Foreign Keys:**
  - order_id → orders(id) ON DELETE CASCADE
  - shop_item_id → shop_items(id)
- **Indexes:** PRIMARY KEY (id), INDEX (order_id)

#### **item_likes**
```
item_likes(
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  shop_item_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  created_at DATETIME,
  UNIQUE KEY (user_id, shop_item_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (shop_item_id) REFERENCES shop_items(id)
)
```
- **Primary Key:** id
- **Foreign Keys:**
  - user_id → users(id)
  - shop_item_id → shop_items(id)
- **Unique Constraint:** (user_id, shop_item_id)
- **Indexes:** PRIMARY KEY (id), UNIQUE (user_id, shop_item_id)

#### **item_comments**
```
item_comments(
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  shop_item_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  comment_text VARCHAR(1000) NOT NULL,
  user_name VARCHAR(32) NOT NULL,
  created_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (shop_item_id) REFERENCES shop_items(id)
)
```
- **Primary Key:** id
- **Foreign Keys:**
  - user_id → users(id)
  - shop_item_id → shop_items(id)
- **Indexes:** PRIMARY KEY (id)

---

## 5. DDL Statements and Normal Form Analysis

### 5.1 Data Definition Language (DDL)

```sql
-- Create users table
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(32) NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    uuid VARCHAR(36) NOT NULL,
    points INT NOT NULL DEFAULT 0,
    address VARCHAR(255),
    last_checkin_date DATE,
    CONSTRAINT uk_users_username UNIQUE (username),
    CONSTRAINT uk_users_uuid UNIQUE (uuid),
    CONSTRAINT chk_points_positive CHECK (points >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create health_coaches table
CREATE TABLE health_coaches (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(32) NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    CONSTRAINT uk_health_coaches_username UNIQUE (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create exercises table
CREATE TABLE exercises (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    type VARCHAR(24) NOT NULL,
    duration_minutes INT NOT NULL,
    location VARCHAR(128),
    occurred_at TIMESTAMP NOT NULL,
    timezone VARCHAR(64),
    CONSTRAINT fk_exercises_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT chk_duration_positive CHECK (duration_minutes >= 1),
    INDEX idx_exercises_user_time (user_id, occurred_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create shop_items table
CREATE TABLE shop_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    points_required INT NOT NULL,
    image_url VARCHAR(255),
    stock INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_points_required CHECK (points_required >= 0),
    CONSTRAINT chk_stock_positive CHECK (stock >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create cart_items table
CREATE TABLE cart_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    shop_item_id BIGINT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_cart_shop_item FOREIGN KEY (shop_item_id) REFERENCES shop_items(id),
    CONSTRAINT chk_cart_quantity CHECK (quantity >= 1),
    INDEX idx_cart_user_item (user_id, shop_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create orders table
CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    total_points INT NOT NULL,
    shipping_address VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_orders_user_time (user_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create order_items table
CREATE TABLE order_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    shop_item_id BIGINT NOT NULL,
    shop_item_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    points_per_item INT NOT NULL,
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
        REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_shop_item FOREIGN KEY (shop_item_id)
        REFERENCES shop_items(id),
    CONSTRAINT chk_order_quantity CHECK (quantity >= 1),
    CONSTRAINT chk_order_points CHECK (points_per_item >= 0),
    INDEX idx_order_items_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create item_likes table
CREATE TABLE item_likes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    shop_item_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_likes_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_likes_shop_item FOREIGN KEY (shop_item_id) REFERENCES shop_items(id),
    UNIQUE KEY uk_user_item_like (user_id, shop_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create item_comments table
CREATE TABLE item_comments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    shop_item_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    comment_text VARCHAR(1000) NOT NULL,
    user_name VARCHAR(32) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_comments_shop_item FOREIGN KEY (shop_item_id) REFERENCES shop_items(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 5.2 Normal Form Analysis

#### **Normal Form Identification: Third Normal Form (3NF)**

The database schema is designed to comply with **Third Normal Form (3NF)**, which requires:
1. The relation must be in Second Normal Form (2NF)
2. No transitive dependencies exist (non-key attributes depend only on primary key)

#### **Justification for Each Table:**

##### **users table - 3NF Compliant**
- **1NF:** All attributes contain atomic values (no repeating groups)
- **2NF:** Primary key (id) is a single column; all non-key attributes depend on the entire primary key
- **3NF:** No transitive dependencies exist
  - username, passwordHash, uuid, points, address, lastCheckinDate all directly depend on id
  - No attribute depends on another non-key attribute

##### **exercises table - 3NF Compliant**
- **1NF:** All attributes are atomic (type is ENUM stored as string, occurredAt is timestamp)
- **2NF:** Single-column primary key (id); all attributes functionally depend on id
- **3NF:** No transitive dependencies
  - user_id is a foreign key (acceptable in 3NF)
  - type, durationMinutes, location, occurredAt, timezone all depend solely on exercise id
  - timezone is stored with each exercise to preserve historical accuracy even if user changes timezone preference

##### **shop_items table - 3NF Compliant**
- **1NF:** All attributes are atomic
- **2NF:** Primary key (id) fully determines all attributes
- **3NF:** No transitive dependencies
  - name, description, pointsRequired, imageUrl, stock are independent attributes
  - No calculated or derived values

##### **cart_items table - 3NF Compliant**
- **1NF:** Atomic attributes (no multi-valued fields)
- **2NF:** Single-column PK; foreign keys user_id and shop_item_id are appropriate
- **3NF:** quantity depends only on the cart item id
  - No redundancy: cart stores current user intent, not duplicated data

##### **orders table - 3NF Compliant**
- **1NF:** All fields are atomic
- **2NF:** Primary key (id) determines all attributes
- **3NF:** No transitive dependencies
  - total_points is derived during order creation but stored to maintain historical accuracy (even if points system changes)
  - shippingAddress is snapshotted at order time (user's address may change later)
  - This is acceptable denormalization for historical data integrity

##### **order_items table - 3NF Compliant with Intentional Denormalization**
- **1NF:** All attributes atomic
- **2NF:** Single-column PK
- **3NF Consideration:** Contains `shop_item_name` and `points_per_item` which could be retrieved from shop_items
  - **Justification for Denormalization:**
    - `shop_item_name`: Stored to preserve historical product names (products may be renamed/deleted)
    - `points_per_item`: Stored to maintain order pricing integrity (product prices may change)
    - This is **acceptable controlled denormalization** for maintaining transactional history
    - Without this, deleted products would cause data loss in order history

##### **item_likes table - 3NF Compliant**
- **1NF:** Atomic attributes
- **2NF:** Single-column PK with unique composite constraint on (user_id, shop_item_id)
- **3NF:** created_at depends only on the like action itself
  - No transitive dependencies

##### **item_comments table - 3NF Compliant with Intentional Denormalization**
- **1NF:** All fields atomic (comment_text is a single text value)
- **2NF:** Primary key (id) fully determines all attributes
- **3NF Consideration:** `user_name` is duplicated from users table
  - **Justification:** Preserves commenter name even if user changes username or account is deleted
  - Trade-off: Slight redundancy for historical data integrity

#### **Summary:**
The database achieves **Third Normal Form (3NF)** with intentional, justified denormalization in:
1. `orders.total_points` and `orders.shipping_address` - Historical snapshot
2. `order_items.shop_item_name` and `order_items.points_per_item` - Transactional integrity
3. `item_comments.user_name` - Historical preservation

These denormalizations prioritize **data integrity over time** rather than pure normalization, which is appropriate for transactional and historical data. The schema avoids **update anomalies** by storing immutable historical snapshots while maintaining **delete and insert anomaly protection** through proper foreign key constraints.

---

## 6. Front-End Design and Back-End Connection

### 6.1 Front-End Architecture

#### **Technology Stack**
1. **UserPortal (End User Interface)**
   - **Framework:** Ionic Framework 8 + Angular 20
   - **UI Library:** Ionic Components (IonCard, IonButton, IonList, etc.)
   - **Charts:** Chart.js 4.5.1 for exercise trend visualization
   - **Routing:** Angular Router with tab-based navigation
   - **State Management:** Angular Services with RxJS Observables
   - **Responsive Design:** Mobile-first design, optimized for phones and tablets

2. **Web-Portal (Admin Dashboard)**
   - **Framework:** Angular 20 (Standalone Components)
   - **UI Library:** Custom CSS with responsive grid layout
   - **Charts:** Chart.js 4.5.1 for user activity monitoring
   - **Routing:** Angular Router with sidebar navigation
   - **State Management:** Angular Services with dependency injection

#### **UserPortal Design Structure**

```
UserPortal/
├── Authentication
│   ├── Login Page: Username/password authentication
│   └── Registration: New user account creation
├── Tab Navigation (Main Interface)
│   ├── Tab 1: Add Exercise
│   │   ├── Exercise type selector (RUN, WALK, CYCLE, etc.)
│   │   ├── Duration input (minutes)
│   │   ├── Location input
│   │   ├── Timezone selector (20+ global timezones)
│   │   ├── Date/time picker
│   │   └── Today's records list
│   ├── Tab 2: Exercise History
│   │   ├── Last 7 days chart (bar chart showing daily minutes)
│   │   └── Complete exercise history list (reverse chronological)
│   ├── Shop Tab
│   │   ├── Product grid with images and prices
│   │   ├── Search/filter functionality
│   │   ├── Add to cart buttons
│   │   └── Stock availability indicators
│   ├── Cart Tab
│   │   ├── Cart items list with quantities
│   │   ├── Total points calculation
│   │   ├── Quantity adjustment controls
│   │   ├── Remove item buttons
│   │   └── Checkout button (validates sufficient points)
│   └── Profile Tab
│       ├── User info card (username, points balance)
│       ├── Daily check-in button (+20 points)
│       ├── Address management (view/edit shipping address)
│       └── Order history (expandable cards with item details)
└── Item Detail Modal
    ├── Product images and description
    ├── Price and stock information
    ├── Add to cart with quantity
    ├── Like/unlike button
    └── Comments section (view and post)
```

**Design Principles:**
- **Mobile-First:** Touch-friendly controls, large tap targets
- **Progressive Disclosure:** Expandable sections to reduce clutter
- **Immediate Feedback:** Loading spinners, success/error messages
- **Offline-Ready Foundation:** LocalStorage for data persistence (future enhancement)

#### **Web-Portal Design Structure**

```
Web-Portal/
├── Authentication
│   ├── Login Page: Admin username/password
│   └── Registration: New admin account creation
└── Main Layout (Sidebar + Content Area)
    ├── Sidebar Navigation
    │   ├── Dashboard (home icon)
    │   ├── Shop Items (store icon)
    │   ├── Orders (bag icon)
    │   └── Users (people icon)
    ├── Dashboard Page
    │   ├── User cards grid
    │   │   ├── Username display
    │   │   ├── Last 7 days total minutes
    │   │   ├── Inactive warning (⚠️ if >2 days)
    │   │   └── View details button
    │   └── User Detail Modal
    │       ├── User information
    │       ├── Last 7 days exercise chart
    │       └── Complete exercise history list
    ├── Shop Items Page
    │   ├── Create new item form (modal)
    │   │   ├── Name, description inputs
    │   │   ├── Points required input
    │   │   ├── Image URL input
    │   │   └── Stock quantity input
    │   ├── Items list/grid
    │   │   ├── Product cards with edit/delete buttons
    │   │   ├── Real-time stock display
    │   │   └── Inline editing capability
    │   └── Confirmation dialogs for destructive actions
    ├── Orders Page
    │   ├── All orders list (sortable by date/user/status)
    │   │   ├── Order ID, user, date, total points
    │   │   ├── Status badge (color-coded)
    │   │   ├── Shipping address
    │   │   ├── Expandable item details
    │   │   └── Action buttons (edit status, delete)
    │   └── Edit order modal
    │       ├── Update status dropdown
    │       ├── Edit shipping address
    │       └── Save/cancel buttons
    └── Users Page
        ├── All users list
        │   ├── Username, points, address
        │   ├── Last activity date
        │   └── Action buttons (edit, delete)
        └── Edit user modal
            ├── Adjust points input
            ├── Update address input
            └── Save/cancel buttons
```

**Design Principles:**
- **Data-Dense Dashboard:** Efficient information display for monitoring
- **CRUD Clarity:** Clear create, read, update, delete operations
- **Warning Indicators:** Visual alerts for inactive users
- **Responsive Tables:** Horizontal scroll on smaller screens

### 6.2 Front-End to Back-End Connection

#### **Communication Architecture**

```
┌─────────────────────────────────┐
│   Front-End (Angular/Ionic)     │
│                                 │
│  ┌──────────────────────────┐  │
│  │  Angular Services        │  │
│  │  - AuthService           │  │
│  │  - ShopService           │  │
│  │  - ExerciseService       │  │
│  │  - UserService           │  │
│  └──────────┬───────────────┘  │
│             │                   │
│             │ HTTP Requests     │
│             │ (JSON)            │
└─────────────┼───────────────────┘
              │
              │ RESTful API
              │ http://localhost:8080/api
              │
┌─────────────▼───────────────────┐
│   Back-End (Spring Boot)        │
│                                 │
│  ┌──────────────────────────┐  │
│  │  REST Controllers        │  │
│  │  @RestController         │  │
│  │  - AuthController        │  │
│  │  - ShopController        │  │
│  │  - ExerciseController    │  │
│  │  - OrderController       │  │
│  │  - UserController        │  │
│  └──────────┬───────────────┘  │
│             │                   │
│             ▼                   │
│  ┌──────────────────────────┐  │
│  │  Service Layer           │  │
│  │  @Service                │  │
│  │  - Business Logic        │  │
│  │  - Validation            │  │
│  │  - Transaction Mgmt      │  │
│  └──────────┬───────────────┘  │
│             │                   │
│             ▼                   │
│  ┌──────────────────────────┐  │
│  │  Repository Layer        │  │
│  │  JpaRepository<T, ID>    │  │
│  │  - CRUD Operations       │  │
│  │  - Custom Queries        │  │
│  └──────────┬───────────────┘  │
│             │                   │
└─────────────┼───────────────────┘
              │
              ▼
      ┌───────────────┐
      │  MySQL DB     │
      │  Port 3306    │
      └───────────────┘
```

#### **Connection Implementation Details**

##### **1. HTTP Client Configuration (Angular)**

**Service Example: ShopService (UserPortal)**
```typescript
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ShopService {
  private apiUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) {}

  // GET request example
  getShopItems(): Observable<ShopItem[]> {
    return this.http.get<ShopItem[]>(`${this.apiUrl}/shop`);
  }

  // POST request example
  checkout(userId: number): Observable<Order> {
    return this.http.post<Order>(
      `${this.apiUrl}/orders/${userId}`,
      {} // Empty body, cart data retrieved by backend
    );
  }

  // PUT request example
  updateAddress(userId: number, address: string): Observable<UserProfile> {
    return this.http.put<UserProfile>(
      `${this.apiUrl}/user/profile/${userId}/address`,
      { address }
    );
  }

  // DELETE request example
  removeFromCart(userId: number, itemId: number): Observable<void> {
    return this.http.delete<void>(
      `${this.apiUrl}/cart/${userId}/${itemId}`
    );
  }
}
```

**Key Features:**
- **Type Safety:** TypeScript interfaces define request/response shapes
- **Reactive Programming:** RxJS Observables for asynchronous operations
- **Error Handling:** Centralized error interceptors (HttpErrorResponse)
- **Base URL Configuration:** Easily configurable API endpoint

##### **2. REST Controller (Spring Boot)**

**Controller Example: OrderController**
```java
@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    // GET all orders (admin)
    @GetMapping
    public ResponseEntity<List<OrderResponse>> getAllOrders() {
        List<OrderResponse> orders = orderService.getAllOrders();
        return ResponseEntity.ok(orders);
    }

    // GET user orders
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<OrderResponse>> getUserOrders(@PathVariable Long userId) {
        List<OrderResponse> orders = orderService.getUserOrders(userId);
        return ResponseEntity.ok(orders);
    }

    // POST create order (checkout)
    @PostMapping("/{userId}")
    public ResponseEntity<?> createOrder(@PathVariable Long userId) {
        try {
            OrderResponse order = orderService.checkout(userId);
            return ResponseEntity.ok(order);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // PUT update order
    @PutMapping("/{orderId}")
    public ResponseEntity<?> updateOrder(
        @PathVariable Long orderId,
        @RequestBody OrderUpdateRequest request
    ) {
        try {
            OrderResponse updated = orderService.updateOrder(orderId, request);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(e.getMessage());
        }
    }

    // DELETE order
    @DeleteMapping("/{orderId}")
    public ResponseEntity<?> deleteOrder(@PathVariable Long orderId) {
        orderService.deleteOrder(orderId);
        return ResponseEntity.ok("Order deleted successfully");
    }
}
```

**Key Features:**
- **RESTful Design:** HTTP methods map to CRUD operations
- **Path Variables:** Dynamic URL parameters (@PathVariable)
- **Request/Response DTOs:** Separate data transfer objects from entities
- **Exception Handling:** Try-catch with appropriate HTTP status codes
- **Validation:** @Valid annotations trigger Bean Validation

##### **3. CORS Configuration**

**Cross-Origin Resource Sharing Setup:**
```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins(
                    "http://localhost:8100",  // UserPortal
                    "http://localhost:4201"   // Web-Portal
                )
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
```

**Purpose:**
- Permits cross-origin requests from frontend applications
- Allows specific HTTP methods
- Enables credentials (cookies, authorization headers) if needed

##### **4. Data Flow Example: Checkout Process**

**Step-by-Step Flow:**

1. **User Action (UserPortal):**
   ```typescript
   // cart.page.ts
   onCheckout() {
     this.shopService.checkout(this.userId).subscribe({
       next: (order) => {
         // Navigate to success page
         this.router.navigate(['/tabs/profile']);
       },
       error: (error) => {
         // Display error message
         alert('Checkout failed: ' + error.error);
       }
     });
   }
   ```

2. **HTTP Request:**
   ```
   POST http://localhost:8080/api/orders/1
   Content-Type: application/json
   Body: {}
   ```

3. **Controller Receives Request:**
   ```java
   @PostMapping("/{userId}")
   public ResponseEntity<?> createOrder(@PathVariable Long userId) {
       OrderResponse order = orderService.checkout(userId);
       return ResponseEntity.ok(order);
   }
   ```

4. **Service Layer Processing:**
   ```java
   @Transactional
   public OrderResponse checkout(Long userId) {
       // 1. Fetch user and validate points
       User user = userRepository.findById(userId)
           .orElseThrow(() -> new IllegalArgumentException("User not found"));

       // 2. Fetch cart items
       List<CartItem> cartItems = cartItemRepository.findByUserId(userId);
       if (cartItems.isEmpty()) {
           throw new IllegalArgumentException("Cart is empty");
       }

       // 3. Calculate total and validate stock
       int totalPoints = 0;
       for (CartItem item : cartItems) {
           ShopItem product = shopItemRepository.findById(item.getShopItemId())
               .orElseThrow(() -> new IllegalArgumentException("Product not found"));

           if (product.getStock() < item.getQuantity()) {
               throw new IllegalArgumentException("Insufficient stock");
           }

           totalPoints += product.getPointsRequired() * item.getQuantity();
       }

       if (user.getPoints() < totalPoints) {
           throw new IllegalArgumentException("Insufficient points");
       }

       // 4. Create order
       Order order = new Order();
       order.setUserId(userId);
       order.setTotalPoints(totalPoints);
       order.setShippingAddress(user.getAddress());
       order.setStatus(Order.OrderStatus.PENDING);
       order.setCreatedAt(ZonedDateTime.now());
       order = orderRepository.save(order);

       // 5. Create order items and update stock
       for (CartItem item : cartItems) {
           ShopItem product = shopItemRepository.findById(item.getShopItemId()).get();

           OrderItem orderItem = new OrderItem();
           orderItem.setOrderId(order.getId());
           orderItem.setShopItemId(product.getId());
           orderItem.setShopItemName(product.getName());
           orderItem.setQuantity(item.getQuantity());
           orderItem.setPointsPerItem(product.getPointsRequired());
           orderItemRepository.save(orderItem);

           // Deduct stock
           product.setStock(product.getStock() - item.getQuantity());
           shopItemRepository.save(product);
       }

       // 6. Deduct points and clear cart
       user.setPoints(user.getPoints() - totalPoints);
       userRepository.save(user);
       cartItemRepository.deleteAll(cartItems);

       // 7. Return response DTO
       return mapToOrderResponse(order);
   }
   ```

5. **Database Transactions:**
   ```sql
   -- All executed within single transaction (@Transactional)
   BEGIN;
   INSERT INTO orders (user_id, total_points, shipping_address, status, created_at)
       VALUES (1, 150, '123 Main St', 'PENDING', '2025-01-15 10:30:00');

   INSERT INTO order_items (order_id, shop_item_id, shop_item_name, quantity, points_per_item)
       VALUES (42, 5, 'Yoga Mat', 2, 50);

   UPDATE shop_items SET stock = stock - 2 WHERE id = 5;
   UPDATE users SET points = points - 150 WHERE id = 1;
   DELETE FROM cart_items WHERE user_id = 1;
   COMMIT;
   ```

6. **HTTP Response:**
   ```json
   {
     "id": 42,
     "userId": 1,
     "totalPoints": 150,
     "shippingAddress": "123 Main St",
     "status": "PENDING",
     "createdAt": "2025-01-15T10:30:00Z",
     "items": [
       {
         "shopItemId": 5,
         "shopItemName": "Yoga Mat",
         "quantity": 2,
         "pointsPerItem": 50
       }
     ]
   }
   ```

7. **Frontend Updates UI:**
   ```typescript
   // Angular component updates view
   this.orders.unshift(order); // Add to order history
   this.userPoints -= order.totalPoints; // Update points display
   this.cartItems = []; // Clear cart view
   ```

#### **Connection Benefits:**
- **Separation of Concerns:** Frontend handles UI, backend handles business logic
- **Type Safety:** DTOs ensure consistent data structures
- **Transaction Safety:** @Transactional ensures atomic operations
- **Error Propagation:** HTTP status codes communicate success/failure
- **Scalability:** Stateless REST API can scale horizontally

---

## 7. System Implementation Overview

### 7.1 Backend Implementation

#### **7.1.1 Project Structure**
```
backend/
├── src/main/java/com/allen/backend/
│   ├── BackendApplication.java         # Spring Boot entry point
│   ├── config/
│   │   └── WebConfig.java              # CORS configuration
│   ├── controller/                     # REST API endpoints
│   │   ├── AuthController.java         # User authentication
│   │   ├── CoachAuthController.java    # Admin authentication
│   │   ├── ExerciseController.java     # Exercise CRUD
│   │   ├── ShopController.java         # Shop item management
│   │   ├── CartController.java         # Shopping cart operations
│   │   ├── OrderController.java        # Order management
│   │   └── UserController.java         # User CRUD (admin)
│   ├── dto/                            # Data Transfer Objects
│   │   ├── LoginRequest.java
│   │   ├── UserResponse.java
│   │   ├── OrderResponse.java
│   │   └── ...
│   ├── entity/                         # JPA Entities
│   │   ├── User.java
│   │   ├── Exercise.java
│   │   ├── ShopItem.java
│   │   ├── Order.java
│   │   └── ...
│   ├── repo/                           # Spring Data Repositories
│   │   ├── UserRepository.java
│   │   ├── ExerciseRepository.java
│   │   └── ...
│   └── service/                        # Business Logic
│       ├── AuthService.java
│       ├── ExerciseService.java
│       ├── ShopService.java
│       ├── OrderService.java
│       └── ...
└── src/main/resources/
    ├── application.properties          # Database config
    └── db/
        └── complete-test-data.sql      # Test data
```

#### **7.1.2 Key Implementation Features**

**Authentication Implementation:**
- **BCrypt Password Hashing:** All passwords stored as BCrypt hashes with salt
  ```java
  BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
  String hashedPassword = encoder.encode(plainPassword);
  ```
- **Separate User Tables:** Users and health_coaches have independent authentication
- **No JWT (Simplified):** Current implementation uses basic authentication (future enhancement)

**Transaction Management:**
- **@Transactional Annotation:** Ensures atomic operations (e.g., checkout process)
- **Rollback on Exception:** Failed transactions automatically roll back all changes

**Validation:**
- **Bean Validation:** @NotBlank, @Size, @Min annotations enforce data integrity
- **Custom Validation:** Service layer checks business rules (e.g., sufficient points)

### 7.2 Frontend Implementation

#### **7.2.1 UserPortal Key Features**

**Exercise Tracking with Timezone:**
```typescript
// timezone.service.ts
export class TimezoneService {
  getTimezones(): Timezone[] {
    return [
      { value: 'America/New_York', label: 'New York (EST/EDT)' },
      { value: 'America/Los_Angeles', label: 'Los Angeles (PST/PDT)' },
      { value: 'Europe/London', label: 'London (GMT/BST)' },
      { value: 'Asia/Tokyo', label: 'Tokyo (JST)' },
      // ... 20+ timezones
    ];
  }
}

// tab1.page.ts (Add Exercise)
onSubmit() {
  const exercise = {
    userId: this.userId,
    type: this.selectedType,
    durationMinutes: this.duration,
    location: this.location,
    occurredAt: this.selectedDateTime.toISOString(),
    timezone: this.selectedTimezone
  };

  this.exerciseService.createExercise(exercise).subscribe({
    next: () => this.loadTodayExercises(),
    error: (err) => alert('Failed to add exercise')
  });
}
```

**Chart.js Integration:**
```typescript
// tab2.page.ts (History)
loadLast7DaysChart() {
  const ctx = document.getElementById('exerciseChart') as HTMLCanvasElement;
  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      datasets: [{
        label: 'Minutes',
        data: this.last7DaysData,
        backgroundColor: 'rgba(54, 162, 235, 0.5)'
      }]
    },
    options: {
      responsive: true,
      scales: { y: { beginAtZero: true } }
    }
  });
}
```

**Shopping Cart State Management:**
```typescript
// shop.service.ts
export class ShopService {
  private cartSubject = new BehaviorSubject<CartItem[]>([]);
  cart$ = this.cartSubject.asObservable();

  addToCart(userId: number, itemId: number, quantity: number) {
    return this.http.post(`${this.apiUrl}/cart/${userId}`, {
      shopItemId: itemId,
      quantity
    }).pipe(
      tap(() => this.loadCart(userId)) // Refresh cart after add
    );
  }

  private loadCart(userId: number) {
    this.http.get<CartItem[]>(`${this.apiUrl}/cart/${userId}`)
      .subscribe(cart => this.cartSubject.next(cart));
  }
}
```

#### **7.2.2 Web-Portal Key Features**

**Admin Dashboard with User Monitoring:**
```typescript
// dashboard.ts
export class Dashboard implements OnInit {
  users: UserSummary[] = [];

  ngOnInit() {
    this.dashboardService.getAllUsers().subscribe(users => {
      this.users = users.map(user => ({
        ...user,
        isInactive: this.calculateInactiveDays(user.lastExerciseDate) > 2
      }));
    });
  }

  calculateInactiveDays(lastDate: string): number {
    if (!lastDate) return 999;
    const last = new Date(lastDate);
    const now = new Date();
    return Math.floor((now.getTime() - last.getTime()) / (1000 * 60 * 60 * 24));
  }
}
```

**CRUD Implementation (Shop Items):**
```typescript
// shop-items.ts
export class ShopItemsComponent {
  items: ShopItem[] = [];
  editingItem: ShopItem | null = null;

  createItem(form: ShopItemForm) {
    this.shopService.createShopItem(form).subscribe({
      next: (item) => {
        this.items.push(item);
        alert('Item created successfully');
      },
      error: (err) => alert('Failed to create item')
    });
  }

  updateItem(id: number, form: ShopItemForm) {
    this.shopService.updateShopItem(id, form).subscribe({
      next: (updated) => {
        const index = this.items.findIndex(i => i.id === id);
        this.items[index] = updated;
        alert('Item updated successfully');
      }
    });
  }

  deleteItem(id: number) {
    if (!confirm('Delete this item?')) return;

    this.shopService.deleteShopItem(id).subscribe({
      next: () => {
        this.items = this.items.filter(i => i.id !== id);
        alert('Item deleted successfully');
      }
    });
  }
}
```

### 7.3 Example Screenshots

#### **UserPortal Screenshots**

**1. Add Exercise Page**
```
┌─────────────────────────────────────────┐
│ ☰ Add Exercise                     🕐 EST│
├─────────────────────────────────────────┤
│                                         │
│  Exercise Type:                         │
│  ┌─────────────────────────────────┐   │
│  │ 🏃 Running                     ▼ │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Duration (minutes):                    │
│  ┌─────────────────────────────────┐   │
│  │ 30                               │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Location:                              │
│  ┌─────────────────────────────────┐   │
│  │ Central Park                     │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Date & Time:                           │
│  ┌─────────────────────────────────┐   │
│  │ 2025-01-15  10:30 AM           │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │     [Add Exercise]               │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Today's Records:                       │
│  ┌─────────────────────────────────┐   │
│  │ 🏃 Running - 30 min              │   │
│  │ 📍 Central Park                  │   │
│  │ 🕐 10:30 AM                  [🗑] │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

**2. Profile with Order History**
```
┌─────────────────────────────────────────┐
│ Profile                                 │
├─────────────────────────────────────────┤
│                                         │
│  👤 Username: allen                     │
│  🏆 Points: 350 pts                     │
│                                         │
│  ┌──────────────────────────────┐      │
│  │  [✓ Daily Check-in (+20pts)] │      │
│  └──────────────────────────────┘      │
│                                         │
│  📍 Shipping Address:                   │
│  123 Main Street, Apt 4B               │
│  [Edit Address]                         │
│                                         │
│  🛍 My Orders:                          │
│  ┌─────────────────────────────────┐   │
│  │ Order #42                       │   │
│  │ 2025-01-15 10:30       150 pts │   │
│  │ 📍 123 Main St           [⌄]   │   │
│  │ Status: [PENDING]              │   │
│  ├─────────────────────────────────┤   │
│  │ Order Items:                    │   │
│  │ • Yoga Mat     50pts × 2 = 100  │   │
│  │ • Water Bottle 25pts × 2 = 50   │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Order #41                       │   │
│  │ 2025-01-10 14:22       200 pts │   │
│  │ Status: [SHIPPED]        [⌄]   │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

#### **Web-Portal Screenshots**

**3. Admin Dashboard**
```
┌────────┬──────────────────────────────────────────────────┐
│        │  Dashboard                Current User: admin    │
│  [📊]  ├──────────────────────────────────────────────────┤
│   Dash │                                                  │
│        │  User Monitoring:                                │
│  [🏪]  │                                                  │
│   Shop │  ┌──────────────┬──────────────┬──────────────┐│
│        │  │ allen        │ john_doe     │ sarah_smith  ││
│  [🛍]  │  │ 350 pts      │ 120 pts      │ 480 pts      ││
│  Orders│  │ Last 7d:     │ Last 7d:     │ Last 7d:     ││
│        │  │ 150 min      │ 45 min       │ 210 min      ││
│  [👥]  │  │ [View]       │ [View] ⚠️   │ [View]       ││
│  Users │  └──────────────┴──────────────┴──────────────┘│
│        │  ⚠️ = Inactive >2 days                          │
│        │                                                  │
│        │  ┌──────────────┬──────────────┬──────────────┐│
│        │  │ mike_johnson │ emma_wilson  │ ...          ││
│        │  │ 275 pts      │ 560 pts      │              ││
│        │  │ Last 7d:     │ Last 7d:     │              ││
│        │  │ 90 min       │ 180 min      │              ││
│        │  │ [View]       │ [View]       │              ││
│        │  └──────────────┴──────────────┴──────────────┘│
└────────┴──────────────────────────────────────────────────┘
```

**4. Shop Items Management**
```
┌────────┬──────────────────────────────────────────────────┐
│        │  Shop Items                  [+ Create New Item] │
│  [📊]  ├──────────────────────────────────────────────────┤
│   Dash │                                                  │
│        │  ┌─────────────────────────────────────────────┐│
│  [🏪]  │  │ Yoga Mat               [Edit] [Delete]      ││
│  *Shop*│  │ Premium non-slip yoga mat                   ││
│        │  │ Price: 50 pts | Stock: 25                   ││
│  [🛍]  │  └─────────────────────────────────────────────┘│
│  Orders│                                                  │
│        │  ┌─────────────────────────────────────────────┐│
│  [👥]  │  │ Resistance Bands       [Edit] [Delete]      ││
│  Users │  │ Set of 5 resistance bands                   ││
│        │  │ Price: 75 pts | Stock: 15                   ││
│        │  └─────────────────────────────────────────────┘│
│        │                                                  │
│        │  ┌─────────────────────────────────────────────┐│
│        │  │ Water Bottle           [Edit] [Delete]      ││
│        │  │ Insulated 32oz bottle                       ││
│        │  │ Price: 25 pts | Stock: 50                   ││
│        │  └─────────────────────────────────────────────┘│
└────────┴──────────────────────────────────────────────────┘
```

**5. Orders Management**
```
┌────────┬──────────────────────────────────────────────────┐
│        │  Orders Management                               │
│  [📊]  ├──────────────────────────────────────────────────┤
│   Dash │                                                  │
│        │  ┌─────────────────────────────────────────────┐│
│  [🏪]  │  │ Order #42 | User: allen | 150pts [⌄]       ││
│   Shop │  │ Date: 2025-01-15 10:30                      ││
│        │  │ Status: [PENDING ▼] [SHIPPED] [DELIVERED]   ││
│  [🛍]  │  │ 📍 123 Main St [Edit] [Delete Order]        ││
│*Orders*│  ├─────────────────────────────────────────────┤│
│        │  │ Items: • Yoga Mat (50pts × 2)               ││
│  [👥]  │  │        • Water Bottle (25pts × 2)           ││
│  Users │  └─────────────────────────────────────────────┘│
│        │                                                  │
│        │  ┌─────────────────────────────────────────────┐│
│        │  │ Order #41 | User: sarah_smith | 200pts [⌄] ││
│        │  │ Date: 2025-01-10 14:22                      ││
│        │  │ Status: [SHIPPED ▼]                         ││
│        │  │ 📍 456 Oak Ave [Edit] [Delete Order]        ││
│        │  └─────────────────────────────────────────────┘│
└────────┴──────────────────────────────────────────────────┘
```

### 7.4 Implementation Highlights

**Successful Implementations:**
✅ Timezone-aware exercise tracking with 20+ global timezones
✅ Points-based economy with daily check-in rewards
✅ Complete shopping cart with quantity management
✅ Order history with expandable item details
✅ Admin CRUD operations for shop items, orders, and users
✅ User activity monitoring with inactive warnings
✅ Chart.js integration for 7-day exercise trends
✅ BCrypt password hashing for security
✅ Transaction-safe checkout process with stock validation
✅ Cascade delete for order items when order is deleted

**Technical Achievements:**
- **Responsive Design:** Mobile-optimized UserPortal, desktop-optimized Web-Portal
- **Real-Time Updates:** Observable-based state management
- **Error Handling:** Comprehensive error messages and validation
- **Data Integrity:** Foreign key constraints and transactional operations

---

## 8. Testing Efforts and Error Handling

### 8.1 Testing Methodology

#### **8.1.1 Manual Testing Approach**
The system has been extensively tested through manual end-to-end testing scenarios covering:
- User registration and authentication flows
- Exercise creation with various timezones
- Shopping cart operations and checkout
- Admin CRUD operations on all entities
- Edge cases and error conditions

#### **8.1.2 Test Data Setup**
**Database:** `complete-test-data.sql` (26KB)
- 13 test users (allen, john_doe, sarah_smith, etc.)
- All passwords: `123` (BCrypt hashed)
- 127 exercise records spanning last 30 days
- 20 shop items with varying prices and stock
- Sample orders and cart items
- Test comments and likes

**Import Script:** `import-test-data.sh`
```bash
#!/bin/bash
mysql -u root -p exercise_tracker < backend/src/main/resources/db/complete-test-data.sql
```

### 8.2 Error Detection and Handling

#### **8.2.1 Authentication Errors**

**Error Case 1: Invalid Login Credentials**
- **Detection:** Backend checks password hash match
- **Handling:**
  ```java
  // AuthService.java
  if (!encoder.matches(plainPassword, user.getPasswordHash())) {
      throw new ResponseStatusException(
          HttpStatus.UNAUTHORIZED,
          "Incorrect password"
      );
  }
  ```
- **Frontend Response:**
  ```typescript
  // login.ts
  error: (error: HttpErrorResponse) => {
    if (error.status === 401) {
      this.errorMessage = 'Invalid username or password';
    }
  }
  ```
- **User Experience:** Clear error message, form remains filled for correction

**Error Case 2: Duplicate Username Registration**
- **Detection:** Unique constraint violation on username column
- **Handling:**
  ```java
  // AuthService.java
  if (userRepository.findByUsername(username).isPresent()) {
      throw new ResponseStatusException(
          HttpStatus.CONFLICT,
          "Username already exists"
      );
  }
  ```
- **Frontend Response:** "Username already exists. Please choose a different username."
- **User Experience:** Prompt to try different username without losing other form data

#### **8.2.2 Exercise Tracking Errors**

**Error Case 3: Invalid Exercise Duration**
- **Detection:** Bean validation (@Min(1)) and frontend validation
- **Handling:**
  ```typescript
  // tab1.page.ts
  if (this.duration < 1 || this.duration > 1440) {
    this.errorMessage = 'Duration must be between 1 and 1440 minutes (24 hours)';
    return;
  }
  ```
- **User Experience:** Inline error message before submission

**Error Case 4: Missing Required Fields**
- **Detection:** @NotBlank, @NotNull annotations on entity
- **Handling:**
  ```java
  // Exercise.java
  @NotNull
  @Column(name = "occurred_at", nullable = false)
  private ZonedDateTime occurredAt;
  ```
- **Backend Response:** 400 Bad Request with field error details
- **User Experience:** Red border on invalid fields, specific error messages

#### **8.2.3 Shopping System Errors**

**Error Case 5: Insufficient Points for Checkout**
- **Detection:** Service layer validation before order creation
- **Handling:**
  ```java
  // OrderService.java
  @Transactional
  public OrderResponse checkout(Long userId) {
      int totalPoints = calculateCartTotal(userId);
      if (user.getPoints() < totalPoints) {
          throw new IllegalArgumentException(
              "Insufficient points. You have " + user.getPoints() +
              " but need " + totalPoints
          );
      }
      // ... proceed with order
  }
  ```
- **Frontend Alert:** "Insufficient points. You have 50 but need 150."
- **User Experience:** Clear explanation, checkout button disabled if insufficient points

**Error Case 6: Out of Stock Product**
- **Detection:** Stock validation during checkout
- **Handling:**
  ```java
  // OrderService.java
  for (CartItem item : cartItems) {
      ShopItem product = shopItemRepository.findById(item.getShopItemId()).get();
      if (product.getStock() < item.getQuantity()) {
          throw new IllegalArgumentException(
              product.getName() + " is out of stock (requested: " +
              item.getQuantity() + ", available: " + product.getStock() + ")"
          );
      }
  }
  ```
- **Frontend Alert:** "Yoga Mat is out of stock (requested: 5, available: 2)."
- **User Experience:** User can adjust cart quantity or remove item

**Error Case 7: Empty Cart Checkout**
- **Detection:** Cart validation at checkout initiation
- **Handling:**
  ```java
  // OrderService.java
  List<CartItem> cartItems = cartItemRepository.findByUserId(userId);
  if (cartItems.isEmpty()) {
      throw new IllegalArgumentException("Cart is empty");
  }
  ```
- **Frontend Alert:** "Your cart is empty. Add items before checkout."
- **User Experience:** Checkout button disabled when cart is empty

#### **8.2.4 Admin Operations Errors**

**Error Case 8: Deleting Non-Existent Entity**
- **Detection:** Repository findById returns Optional.empty()
- **Handling:**
  ```java
  // ShopService.java
  public void deleteShopItem(Long id) {
      ShopItem item = shopItemRepository.findById(id)
          .orElseThrow(() -> new RuntimeException("Shop item not found"));
      shopItemRepository.delete(item);
  }
  ```
- **Frontend Response:** 404 Not Found with error message
- **User Experience:** Alert: "Item not found. It may have been already deleted."

**Error Case 9: Invalid Point Adjustment**
- **Detection:** Frontend validation prevents negative point adjustments beyond user's balance
- **Handling:**
  ```typescript
  // users.component.ts
  adjustPoints(userId: number, adjustment: number) {
    const user = this.users.find(u => u.id === userId);
    if (user.points + adjustment < 0) {
      alert('Cannot reduce points below zero');
      return;
    }
    // ... proceed with update
  }
  ```
- **User Experience:** Warning before applying adjustment, confirmation dialog

#### **8.2.5 Network and Connectivity Errors**

**Error Case 10: Backend Server Unavailable**
- **Detection:** HTTP request timeout or connection refused
- **Handling:**
  ```typescript
  // All services
  error: (error: HttpErrorResponse) => {
    if (error.status === 0) {
      this.errorMessage = 'Cannot connect to server. Please check your connection.';
    }
  }
  ```
- **User Experience:** Friendly message prompting to check connection and retry

**Error Case 11: Database Connection Failure**
- **Detection:** Spring Boot cannot establish connection on startup
- **Handling:** Application fails to start with clear error log
  ```
  Error: Communications link failure
  Solution: Check MySQL service status and application.properties
  ```
- **Developer Experience:** Startup script checks database connection first

### 8.3 Input Validation Summary

| Input Field | Frontend Validation | Backend Validation | Error Message |
|-------------|--------------------|--------------------|---------------|
| Username | 3-32 chars, required | @Size(min=3, max=32), @NotBlank, unique | "Username must be 3-32 characters" |
| Password | 3-100 chars, required | @Size(min=3, max=100), @NotBlank | "Password must be 3-100 characters" |
| Exercise Duration | 1-1440 min, required | @Min(1), @NotNull | "Duration must be at least 1 minute" |
| Exercise Type | Selection required | @Enumerated, @NotNull | "Please select exercise type" |
| Shop Item Points | >= 0, required | @Min(0), @NotNull | "Points must be non-negative" |
| Shop Item Stock | >= 0, required | @Min(0), @NotNull | "Stock must be non-negative" |
| Cart Quantity | >= 1, required | @Min(1), @NotNull | "Quantity must be at least 1" |
| Order Address | Max 255 chars | @Size(max=255) | "Address too long (max 255 characters)" |

### 8.4 Transaction Rollback Scenarios

**Scenario 1: Checkout Fails After Stock Deduction**
- **Problem:** If system crashes after reducing stock but before saving order
- **Solution:** @Transactional ensures atomic operation
- **Result:** Stock is automatically rolled back if any step fails

**Scenario 2: Points Deducted But Order Not Created**
- **Problem:** User loses points without receiving order
- **Solution:** All checkout steps within single transaction
- **Result:** Either all operations succeed or none do (atomic)

### 8.5 Testing Coverage

**Tested Scenarios:**
✅ User registration with valid/invalid credentials
✅ Login with correct/incorrect passwords
✅ Exercise creation across different timezones
✅ Exercise deletion
✅ Adding items to cart (single and multiple)
✅ Updating cart quantities
✅ Removing items from cart
✅ Checkout with sufficient/insufficient points
✅ Checkout with in-stock/out-of-stock items
✅ Daily check-in (once per day restriction)
✅ Address update
✅ Order history viewing
✅ Admin shop item CRUD operations
✅ Admin order status updates
✅ Admin user point adjustments
✅ User inactivity detection (>2 days)
✅ Chart rendering with 7-day data
✅ Empty cart prevention
✅ Negative point prevention

**Error Scenarios Tested:**
✅ Invalid login credentials
✅ Duplicate username registration
✅ Invalid exercise duration
✅ Empty required fields
✅ Insufficient points checkout
✅ Out of stock checkout
✅ Empty cart checkout
✅ Deleting non-existent entities
✅ Network connectivity issues
✅ Database connection failures

---

## 9. System Limitations and Future Improvements

### 9.1 Current Limitations

#### **9.1.1 Authentication and Security**
**Limitation 1: No Token-Based Authentication**
- **Current State:** Basic authentication with username/password only
- **Impact:** Cannot implement session timeout, multi-device logout, or secure API access
- **Workaround:** Users must trust browser localStorage

**Limitation 2: No Password Reset Functionality**
- **Current State:** Forgotten passwords require admin intervention
- **Impact:** Poor user experience, increased support burden
- **Workaround:** Admin must manually reset password in database

**Limitation 3: No Role-Based Access Control (RBAC)**
- **Current State:** Binary permission model (user or admin)
- **Impact:** Cannot have moderators, shop managers, or other intermediate roles
- **Workaround:** All admin functions available to all health coaches

#### **9.1.2 Data Management**
**Limitation 4: No Soft Delete**
- **Current State:** Deleted users/products are permanently removed
- **Impact:** Data loss, cannot restore accidentally deleted records
- **Workaround:** Database backups required

**Limitation 5: No Pagination**
- **Current State:** All data loaded at once (e.g., all shop items, all orders)
- **Impact:** Performance degrades with large datasets
- **Workaround:** Acceptable for small-to-medium datasets (<1000 records)

**Limitation 6: No Search/Filter on Large Lists**
- **Current State:** Admin must manually scroll through user/order lists
- **Impact:** Difficult to find specific records in large datasets
- **Workaround:** Browser Ctrl+F for text search

#### **9.1.3 Business Logic**
**Limitation 7: No Point Refund System**
- **Current State:** Points deducted during checkout cannot be refunded
- **Impact:** User dissatisfaction if order issue occurs
- **Workaround:** Admin can manually adjust user points

**Limitation 8: Fixed Daily Check-in Reward**
- **Current State:** Always +20 points per check-in
- **Impact:** Cannot incentivize streaks or special events
- **Workaround:** Admin can manually add bonus points

**Limitation 9: No Exercise Goal Tracking**
- **Current State:** Users can only view history, no goal-setting
- **Impact:** Lower user engagement and motivation
- **Workaround:** Users must track goals externally

#### **9.1.4 User Experience**
**Limitation 10: No Real-Time Notifications**
- **Current State:** Users must manually refresh to see order status updates
- **Impact:** Poor user experience for order tracking
- **Workaround:** Users must periodically check profile page

**Limitation 11: No Product Images Upload**
- **Current State:** Admin must provide image URLs (external hosting)
- **Impact:** Dependency on external image services
- **Workaround:** Use image hosting services like Imgur

**Limitation 12: No Mobile Native App**
- **Current State:** Ionic app runs as web app, not native mobile
- **Impact:** Cannot access device features (GPS, fitness tracker integration)
- **Workaround:** Progressive Web App (PWA) provides some mobile features

#### **9.1.5 Technical Limitations**
**Limitation 13: No Caching**
- **Current State:** Every request hits database
- **Impact:** Unnecessary database load, slower response times
- **Workaround:** MySQL query cache provides minimal optimization

**Limitation 14: No Rate Limiting**
- **Current State:** API has no request throttling
- **Impact:** Vulnerable to abuse and DDoS attacks
- **Workaround:** Rely on network-level protections

**Limitation 15: No Automated Testing**
- **Current State:** Only manual testing performed
- **Impact:** Risk of regression bugs when adding features
- **Workaround:** Thorough manual testing before deployment

### 9.2 Possibilities for Improvement

#### **9.2.1 High-Priority Enhancements**

**Improvement 1: JWT Authentication**
- **Implementation:** Add Spring Security with JWT tokens
- **Benefits:**
  - Secure session management
  - Token expiration and refresh
  - Stateless authentication for scalability
- **Effort:** Medium (2-3 days)

**Improvement 2: Email Notifications**
- **Implementation:** Integrate JavaMailSender with order status updates
- **Benefits:**
  - Users notified when order status changes
  - Password reset via email link
  - Marketing opportunities (new products, promotions)
- **Effort:** Medium (2-3 days)

**Improvement 3: Pagination and Search**
- **Implementation:** Add Spring Data JPA Pageable and search parameters
- **Benefits:**
  - Handle thousands of records efficiently
  - Improved user experience for admins
  - Better database performance
- **Effort:** Low-Medium (1-2 days)

**Improvement 4: Product Image Upload**
- **Implementation:** Add multipart file upload with local/S3 storage
- **Benefits:**
  - Self-contained system (no external dependencies)
  - Admin can directly upload images
  - Consistent image sizing and quality
- **Effort:** Medium (2-3 days)

#### **9.2.2 Feature Enhancements**

**Improvement 5: Exercise Goals and Streaks**
- **Implementation:** Add user goals table and streak calculation logic
- **Features:**
  - Set weekly/monthly exercise targets
  - Track daily exercise streaks
  - Achievement badges for milestones
  - Bonus points for streak milestones (e.g., 7-day, 30-day)
- **Benefits:**
  - Increased user engagement
  - Gamification improves retention
- **Effort:** High (1 week)

**Improvement 6: Social Features**
- **Implementation:** Expand comments/likes system
- **Features:**
  - User profiles with exercise statistics
  - Leaderboards (most active users, highest streaks)
  - Friend system and activity feed
  - Share achievements on social media
- **Benefits:**
  - Community building
  - Viral growth potential
- **Effort:** High (2 weeks)

**Improvement 7: Advanced Analytics Dashboard**
- **Implementation:** Add analytics service with aggregation queries
- **Features:**
  - System-wide statistics (total exercises, active users)
  - Revenue analytics (points spent, popular products)
  - User cohort analysis
  - Exercise type distribution charts
- **Benefits:**
  - Data-driven decision making
  - Identify trends and patterns
- **Effort:** Medium-High (1 week)

**Improvement 8: Order Refund System**
- **Implementation:** Add order cancellation and refund workflow
- **Features:**
  - Users can cancel pending orders
  - Admin can issue refunds
  - Points automatically credited back
  - Stock restored on cancellation
- **Benefits:**
  - Better customer satisfaction
  - Flexible error handling
- **Effort:** Medium (3-4 days)

#### **9.2.3 Technical Improvements**

**Improvement 9: Redis Caching**
- **Implementation:** Add Spring Cache with Redis
- **Cached Data:**
  - Shop items list (high read frequency)
  - User profile data
  - Exercise statistics
- **Benefits:**
  - 10-100x faster response times
  - Reduced database load
- **Effort:** Medium (2-3 days)

**Improvement 10: Automated Testing Suite**
- **Implementation:** Add JUnit + Mockito for backend, Jasmine for frontend
- **Coverage:**
  - Unit tests for services and repositories
  - Integration tests for API endpoints
  - E2E tests for critical user flows
- **Benefits:**
  - Confidence in code changes
  - Faster development cycles
  - Reduced regression bugs
- **Effort:** High (2 weeks initial, ongoing)

**Improvement 11: CI/CD Pipeline**
- **Implementation:** GitHub Actions for automated build/test/deploy
- **Pipeline:**
  - Run tests on every commit
  - Build Docker images
  - Deploy to staging/production
- **Benefits:**
  - Faster deployment cycles
  - Reduced human error
- **Effort:** Medium-High (3-5 days)

**Improvement 12: API Rate Limiting**
- **Implementation:** Spring Security rate limiting or API Gateway
- **Configuration:**
  - 100 requests/minute per user
  - 10 requests/minute for login attempts
- **Benefits:**
  - Protection against abuse
  - Fair resource distribution
- **Effort:** Low-Medium (1-2 days)

#### **9.2.4 Scalability Improvements**

**Improvement 13: Database Optimization**
- **Implementation:**
  - Add composite indexes on frequently queried columns
  - Implement database connection pooling (HikariCP)
  - Add read replicas for reporting queries
- **Benefits:**
  - Support 10,000+ users
  - Sub-100ms query times
- **Effort:** Medium (3-5 days)

**Improvement 14: Microservices Architecture**
- **Implementation:** Split into separate services
  - User service (authentication, profiles)
  - Exercise service (tracking, analytics)
  - Shop service (products, orders)
- **Benefits:**
  - Independent scaling
  - Technology flexibility
  - Fault isolation
- **Effort:** Very High (1-2 months)

**Improvement 15: Mobile Native App**
- **Implementation:** Convert Ionic to native iOS/Android apps
- **Features:**
  - Push notifications for order updates
  - Fitness tracker integration (Apple Health, Google Fit)
  - GPS location tracking for exercises
  - Offline mode with background sync
- **Benefits:**
  - Better user experience
  - Access to device features
  - App store presence
- **Effort:** Very High (2-3 months)

### 9.3 Improvement Roadmap

**Phase 1: Security & Stability (2-3 weeks)**
1. JWT Authentication
2. Email Notifications
3. Automated Testing Suite (basic coverage)
4. API Rate Limiting

**Phase 2: User Experience (3-4 weeks)**
1. Pagination and Search
2. Product Image Upload
3. Exercise Goals and Streaks
4. Order Refund System

**Phase 3: Performance & Scale (2-3 weeks)**
1. Redis Caching
2. Database Optimization
3. CI/CD Pipeline

**Phase 4: Advanced Features (4-6 weeks)**
1. Social Features
2. Advanced Analytics Dashboard
3. Mobile Native App (iOS first, then Android)

**Phase 5: Enterprise (8+ weeks)**
1. Microservices Architecture
2. Multi-tenant Support
3. White-label Solution

---

## Conclusion

The Exercise Tracker & Points Shopping System successfully demonstrates a full-stack application with comprehensive CRUD operations, transactional integrity, and user-friendly interfaces. The system achieves its core objectives of promoting fitness through gamification while maintaining data consistency and security.

**Key Achievements:**
- Third Normal Form (3NF) database design with justified denormalization
- RESTful API architecture with clear separation of concerns
- Responsive frontend applications for both end users and administrators
- Robust error handling and input validation
- Transaction-safe operations for critical business logic

**Production Readiness:**
The system is currently suitable for small-to-medium deployments (100-1000 users) and serves as a strong foundation for future enhancements. With the proposed improvements, the system can scale to enterprise-level deployments supporting 10,000+ users with advanced features like real-time notifications, social networking, and mobile native apps.

---

**Report Generated:** January 2025
**Project Repository:** https://github.com/Allen11204/exercise-tracker
**Technology Stack:** Spring Boot 3.5.7, Angular 20, Ionic 8, MySQL 8.0, Chart.js 4.5.1
