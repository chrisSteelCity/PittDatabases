# Exercise Tracker & Points Shopping System

A full-stack fitness and rewards application with exercise tracking, points-based shopping system, and comprehensive admin management.

## 📋 Project Overview

This project consists of three main components:

1. **Backend** - Spring Boot REST API (Java) with MySQL database
2. **UserPortal** - Ionic Angular mobile app for end users
3. **Web-Portal** - Angular web dashboard for administrators

## ✨ Key Features

### UserPortal (Mobile App)
- **Exercise Tracking**
  - Add exercise records (Running, Walking, Cycling, Swimming, Gym, Other)
  - Timezone-aware recording
  - View last 7 days exercise chart
  - Browse complete exercise history

- **Points & Rewards System**
  - Daily check-in rewards (+20 points)
  - Shop for fitness products using earned points
  - Browse available items with stock information
  - Shopping cart management
  - Order history with expandable details

- **Profile Management**
  - View current points balance
  - Update shipping address
  - View all order history with status tracking
  - Order details with item breakdowns

### Web-Portal (Admin Dashboard)
- **User Monitoring**
  - Dashboard showing all users
  - View user exercise activity
  - Last 7 days exercise trends
  - User details with complete history

- **Shop Management**
  - Full CRUD operations for shop items
  - Manage product inventory
  - Set points required for each item
  - Upload product images

- **Order Management**
  - View all orders across users
  - Update order status (PENDING → SHIPPED → DELIVERED)
  - Update shipping addresses
  - Delete orders

- **User Management**
  - View all registered users
  - Update user points
  - Update user addresses
  - Delete users

## 🛠️ Tech Stack

### Backend
- Java 17+
- Spring Boot 3.5.7
- Spring Data JPA
- MySQL 8.0+
- Maven
- BCrypt password encryption

### UserPortal (Mobile)
- Angular 20
- Ionic Framework 8
- Capacitor 7
- Chart.js 4.5.1
- TypeScript 5.8

### Web-Portal (Admin Dashboard)
- Angular 20
- Chart.js 4.5.1
- TypeScript 5.9
- Standalone Components

## 📦 Prerequisites

### Required Software

1. **Java Development Kit (JDK) 17 or higher**
   - Check version: `java -version`
   - Download: https://adoptium.net/

2. **Maven 3.6+**
   - Check version: `mvn -version`
   - Download: https://maven.apache.org/download.cgi
   - macOS install: `brew install maven`

3. **Node.js 18+ and npm**
   - Check version: `node -v` and `npm -v`
   - Download: https://nodejs.org/
   - Recommended: Use LTS version

4. **MySQL 8.0+**
   - Check version: `mysql --version`
   - Download: https://dev.mysql.com/downloads/mysql/
   - macOS install: `brew install mysql`

5. **Ionic CLI** (for UserPortal)
   - Global install: `npm install -g @ionic/cli`
   - Check version: `ionic -v`

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/Allen11204/exercise-tracker.git
cd exercise-tracker
```

### 2. Database Setup

#### Start MySQL Service
```bash
# macOS (Homebrew)
brew services start mysql

# Or start directly
mysql.server start
```

#### Setup Database & Import Test Data
One-command setup (creates database + imports test data):
```bash
./import-test-data.sh
```

This will:
- Create the `exercise_tracker` database
- Import 13 test users and 127 exercise records
- Import 20 shop items with inventory
- All users have password: `123`

**Test Login:**
- Username: `allen` (or any user: `john_doe`, `sarah_smith`, etc.)
- Password: `123`

#### Manual setup (if you prefer):
```bash
mysql -u root -p
CREATE DATABASE exercise_tracker CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit;
mysql -u root -p exercise_tracker < backend/src/main/resources/db/complete-test-data.sql
```

#### Configure Database Connection
Edit `backend/src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/exercise_tracker?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=utf8
spring.datasource.username=root
spring.datasource.password=YOUR_MYSQL_PASSWORD
```
**Note:** Replace `YOUR_MYSQL_PASSWORD` with your actual MySQL password.

### 3. Start All Services

#### Option A: One-Command Start (Recommended) 🚀
Start everything with one command and auto-open browsers:
```bash
./start-all.sh
```

This will:
- Start Backend (Spring Boot) on port 8080
- Start UserPortal (Ionic) on port 8100
- Start Web-Portal (Angular) on port 4201
- Auto-open browser windows
- Show all logs in `logs/` directory

**To stop:** Press `Ctrl+C`

#### Option B: Manual Start (3 separate terminals)

**Terminal 1 - Backend:**
```bash
cd backend
./mvnw spring-boot:run
```
Backend will start at http://localhost:8080

**Terminal 2 - UserPortal:**
```bash
cd userPortal
npm install
ionic serve --port 8100
```
UserPortal will start at http://localhost:8100

**Terminal 3 - Web-Portal:**
```bash
cd web-portal
npm install
ng serve --port 4201
```
Web-Portal will start at http://localhost:4201

## 🖥️ Access the Application

| Service | URL | Description |
|---------|-----|-------------|
| Backend API | http://localhost:8080 | REST API |
| UserPortal | http://localhost:8100 | User mobile app (Ionic) |
| Web-Portal | http://localhost:4201 | Admin dashboard (Angular) |

## 📱 How to Use

### UserPortal (End Users)

#### 1. Register/Login
- Open http://localhost:8100
- Register a new user or login with existing account
- Test account: `allen` / password: `123`

#### 2. Exercise Tracking
- Navigate to "Add Exercise" tab
- Select timezone (top right corner)
- Fill in exercise type, duration, date/time, location
- Click "Add Exercise" to save
- Record appears immediately in "Today's Records" list

#### 3. View History
- Navigate to "History" tab
- View last 7 days exercise chart
- Browse all historical exercise records

#### 4. Shopping & Points
- Navigate to "Shop" tab
- Browse available fitness products
- Add items to cart
- Checkout using earned points
- View order confirmation

#### 5. Profile & Orders
- Navigate to "Profile" tab
- View current points balance
- Daily check-in for bonus points
- Update shipping address
- **View all order history**
- Click on any order to see item details
- Track order status

### Web-Portal (Administrators)

#### 1. Register/Login
- Open http://localhost:4201
- Register as an admin or login
- Username will be displayed in top-right corner

#### 2. Dashboard
- View all registered users
- See user exercise activity
- ⚠️ indicator shows users inactive for >2 days
- Click user to view detailed exercise data

#### 3. User Details
- View user's last 7 days exercise trend chart
- Browse user's complete exercise history

#### 4. Shop Items Management
- Click "Shop Items" in sidebar
- **Create** new products with points, stock, images
- **Edit** existing products
- **Delete** products
- View real-time inventory

#### 5. Orders Management
- Click "Orders" in sidebar
- View all orders from all users
- **Update** order status (PENDING/SHIPPED/DELIVERED)
- **Edit** shipping addresses
- **Delete** orders
- Expand orders to see item details

#### 6. Users Management
- Click "Users" in sidebar
- View all registered users
- **Update** user points (reward/adjust)
- **Update** user addresses
- **Delete** users

## 🗄️ Database Schema

### Main Tables
- **users** - End users (username, password_hash, uuid, points, address)
- **health_coaches** - Admin users (username, password_hash)
- **exercises** - Exercise records (user_id, type, duration_minutes, location, occurred_at, timezone)
- **shop_items** - Products (name, description, points_required, image_url, stock)
- **cart_items** - Shopping carts (user_id, shop_item_id, quantity)
- **orders** - Orders (user_id, total_points, shipping_address, status, created_at)
- **order_items** - Order details (order_id, shop_item_id, quantity, points_per_item)
- **item_likes** - Product likes (user_id, shop_item_id)
- **item_comments** - Product comments (user_id, shop_item_id, comment_text)

### Exercise Types
- RUN (Running)
- WALK (Walking)
- CYCLE (Cycling)
- SWIM (Swimming)
- GYM (Gym workout)
- OTHER (Other activities)

### Order Status
- PENDING - Order placed, awaiting processing
- SHIPPED - Order has been shipped
- DELIVERED - Order completed

## 🌍 Timezone Support

The application supports 20+ global timezones including:

- **Americas:** New York, Chicago, Denver, Los Angeles
- **Europe:** London, Paris, Berlin, Rome
- **Asia:** Tokyo, Shanghai, Hong Kong, Singapore, Dubai
- **Australia:** Sydney, Melbourne

Each exercise record saves the timezone it was created in, ensuring accurate time display.

## 📊 Core Features Summary

### ✅ UserPortal
- User registration/login
- Add/edit/delete exercise records (with timezone)
- Offline data storage (LocalStorage)
- Auto-sync to backend
- View exercise history with charts
- Points-based shopping system
- Shopping cart management
- Order placement
- **Order history with expandable details**
- Daily check-in rewards
- Profile management
- Address management

### ✅ Web-Portal
- Admin registration/login
- User monitoring dashboard
- User activity alerts (inactive >2 days)
- User exercise details with charts
- **Complete shop items management (CRUD)**
- **Complete orders management (CRUD)**
- **Complete users management (CRUD)**
- Real-time data synchronization
- Authenticated username display

### ✅ Backend
- RESTful API design
- BCrypt password hashing
- CORS configuration
- Input validation
- SQL injection prevention (JPA/Hibernate)
- **Full shop items API**
- **Full orders API with cascade delete**
- **Full users management API**
- Transaction management
- Error handling

## 🔒 Security

- BCrypt password hashing (all passwords)
- CORS cross-origin configuration
- Input validation (frontend + backend)
- SQL injection prevention (JPA/Hibernate)
- Password strength requirements
- Authentication tokens stored in localStorage

## 🔧 Troubleshooting

### Backend Fails to Start

**Error: Communications link failure**
- Check if MySQL is running: `mysql.server status`
- Check if database exists: `SHOW DATABASES;`
- Verify username/password in `application.properties`

**Error: mvnw: command not found**
- Ensure you're in the backend directory
- Add execute permission: `chmod +x mvnw`
- Or use system Maven: `mvn spring-boot:run`

### UserPortal or Web-Portal Fails to Start

**Error: Cannot find module**
```bash
# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

**Port Already in Use**
```bash
# Find process using port
lsof -ti:8100  # UserPortal
lsof -ti:4201  # Web-Portal

# Kill process
kill -9 <PID>
```

### Database Password Issues

If MySQL has no password or password is not root:
- Edit `backend/src/main/resources/application.properties`
- Change `spring.datasource.password` to your actual password
- If no password, set to empty: `spring.datasource.password=`

### CORS Errors

If frontend cannot access backend API, check:
- Backend is running at http://localhost:8080
- Frontend is running on correct port (8100 or 4201)
- CORS configuration in `WebConfig.java` includes your frontend URL

## 📁 Project Structure

```
exercise-tracker/
├── backend/                    # Spring Boot backend
│   ├── src/
│   │   └── main/
│   │       ├── java/com/allen/backend/
│   │       │   ├── config/    # CORS, security config
│   │       │   ├── controller/# REST API controllers
│   │       │   │   ├── AuthController.java
│   │       │   │   ├── CoachAuthController.java
│   │       │   │   ├── ExerciseController.java
│   │       │   │   ├── ShopController.java
│   │       │   │   ├── CartController.java
│   │       │   │   ├── OrderController.java
│   │       │   │   ├── UserController.java
│   │       │   │   └── ...
│   │       │   ├── dto/       # Data Transfer Objects
│   │       │   ├── entity/    # JPA entities
│   │       │   ├── repo/      # JPA repositories
│   │       │   └── service/   # Business logic
│   │       │       ├── ShopService.java
│   │       │       ├── OrderService.java
│   │       │       ├── UserService.java
│   │       │       └── ...
│   │       └── resources/
│   │           ├── application.properties
│   │           └── db/
│   │               └── complete-test-data.sql
│   └── pom.xml
│
├── userPortal/                # Ionic Angular user app
│   ├── src/
│   │   └── app/
│   │       ├── auth/          # Login/register
│   │       ├── tab1/          # Add exercise (renamed from tab1)
│   │       ├── tab2/          # Exercise history
│   │       ├── shop/          # Shopping page
│   │       ├── cart/          # Shopping cart
│   │       ├── profile/       # User profile & order history
│   │       ├── tabs/          # Tab navigation
│   │       └── services/      # API services
│   │           ├── shop.service.ts
│   │           └── timezone.service.ts
│   └── package.json
│
└── web-portal/                # Angular admin dashboard
    ├── src/
    │   └── app/
    │       ├── login/         # Admin login
    │       ├── dashboard/     # User monitoring
    │       ├── user-list/     # User details
    │       ├── components/
    │       │   └── main-layout/  # Sidebar layout
    │       ├── admin/
    │       │   ├── shop-items/   # Shop management
    │       │   ├── orders/       # Order management
    │       │   └── users/        # User management
    │       └── services/      # API services
    │           ├── auth.ts
    │           ├── shop.ts
    │           ├── order.ts
    │           └── user.ts
    └── package.json
```

## 🔄 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/coach/register` - Admin registration
- `POST /api/coach/login` - Admin login

### Exercise Management
- `GET /api/exercises/user/{userId}` - Get user exercises
- `POST /api/exercises` - Create exercise
- `PUT /api/exercises/{id}` - Update exercise
- `DELETE /api/exercises/{id}` - Delete exercise
- `POST /api/exercises/sync` - Batch sync exercises

### Shop & Cart
- `GET /api/shop` - Get all shop items
- `GET /api/shop/available` - Get available items (stock > 0)
- `GET /api/shop/{id}` - Get item by ID
- `POST /api/shop` - Create shop item (admin)
- `PUT /api/shop/{id}` - Update shop item (admin)
- `DELETE /api/shop/{id}` - Delete shop item (admin)
- `GET /api/cart/{userId}` - Get user cart
- `POST /api/cart/{userId}` - Add to cart
- `PUT /api/cart/{userId}/{itemId}` - Update cart quantity
- `DELETE /api/cart/{userId}/{itemId}` - Remove from cart

### Orders
- `POST /api/orders/{userId}` - Create order
- `GET /api/orders/{orderId}` - Get order by ID
- `GET /api/orders/user/{userId}` - Get user orders
- `GET /api/orders` - Get all orders (admin)
- `PUT /api/orders/{orderId}` - Update order (admin)
- `DELETE /api/orders/{orderId}` - Delete order (admin)

### User Management
- `GET /api/user/profile/{userId}` - Get user profile
- `PUT /api/user/profile/{userId}/address` - Update address
- `POST /api/user/profile/{userId}/checkin` - Daily check-in
- `GET /api/user/all` - Get all users (admin)
- `PUT /api/user/{userId}` - Update user (admin)
- `DELETE /api/user/{userId}` - Delete user (admin)

### Social Features
- `POST /api/items/{itemId}/like` - Toggle like
- `GET /api/items/{itemId}/like/status` - Get like status
- `GET /api/items/{itemId}/like/count` - Get like count
- `POST /api/items/{itemId}/comments` - Add comment
- `GET /api/items/{itemId}/comments` - Get comments

## 📝 Development Notes

### Important Configurations
- **Database auto-update:** `spring.jpa.hibernate.ddl-auto=update` automatically creates/updates tables
- **CORS:** Configured in `WebConfig.java` for `localhost:8100` and `localhost:4201`
- **Ports:**
  - Backend: 8080
  - UserPortal: 8100
  - Web-Portal: 4201

### Test Data
- 13 test users (allen, john_doe, sarah_smith, etc.)
- All passwords: `123`
- 127 exercise records across last 30 days
- 20 shop items with various prices and stock
- Sample orders and cart items

## 🤝 Contributing

Issues and Pull Requests are welcome!

## 📄 License

MIT License

## 📞 Contact

For questions, please contact via GitHub Issues.
