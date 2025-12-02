# 积分商城系统功能说明

本文档介绍了新增的积分商城系统功能。

## 功能概述

### 用户端 (userPortal)

#### 1. 商品商城 (Shop)
- 路径: `/tabs/shop`
- 功能:
  - 浏览所有可用商品
  - 查看商品详情(名称、描述、所需积分、库存)
  - 将商品加入购物车
  - 实时显示用户当前积分余额

#### 2. 购物车 (Cart)
- 路径: `/tabs/cart`
- 功能:
  - 查看购物车中的所有商品
  - 增加或减少商品数量
  - 删除购物车中的商品
  - 查看总计所需积分
  - 下单功能(积分充足时)
  - 实时积分余额显示

#### 3. 个人中心 (Profile)
- 路径: `/tabs/profile`
- 功能:
  - 查看用户信息和当前积分
  - **每日签到功能** - 每天签到可获得 20 积分
  - 查看上次签到日期
  - 设置/修改收货地址
  - 积分余额显示

### 管理端 (webPortal)

#### UserList 页面增强
- 路径: `/user-list/:userId`
- 新增功能:
  - **购买记录列表** - 显示用户的所有订单
  - 订单详情包括:
    - 订单号
    - 下单时间
    - 订单状态(待处理/处理中/已发货/已送达/已取消)
    - 消耗的总积分
    - 收货地址
    - 订单商品清单(商品名称、数量、单价、小计)
  - 分页显示订单记录

## 积分系统

### 获取积分方式
1. **每日签到**: 20 积分/次
2. **添加运动记录**: 50 积分/次
   - 在 "Add Exercise" 页面添加运动记录时自动获得
   - 批量同步记录时,每条记录也会获得 50 积分

### 消耗积分
- 在商城购买商品时消耗积分
- 商品价格范围: 300-400 积分左右

## 后端 API

### Shop APIs
```
GET  /api/shop              - 获取所有商品
GET  /api/shop/available    - 获取有库存的商品
GET  /api/shop/{id}         - 获取单个商品详情
```

### Cart APIs
```
GET    /api/cart/{userId}                  - 获取用户购物车
POST   /api/cart/{userId}                  - 添加商品到购物车
PUT    /api/cart/{userId}/{cartItemId}     - 更新购物车商品数量
DELETE /api/cart/{userId}/{cartItemId}     - 删除购物车商品
DELETE /api/cart/{userId}                  - 清空购物车
```

### Order APIs
```
POST /api/orders/{userId}        - 创建订单
GET  /api/orders/{orderId}       - 获取订单详情
GET  /api/orders/user/{userId}   - 获取用户所有订单
GET  /api/orders                 - 获取所有订单(管理员)
```

### User Profile APIs
```
GET  /api/user/profile/{userId}          - 获取用户资料
PUT  /api/user/profile/{userId}/address  - 更新收货地址
POST /api/user/profile/{userId}/checkin  - 每日签到
```

## 数据库表结构

### shop_items (商品表)
- id: 商品ID
- name: 商品名称
- description: 商品描述
- points_required: 所需积分
- image_url: 商品图片URL
- stock: 库存数量

### cart_items (购物车表)
- id: 购物车项ID
- user_id: 用户ID
- shop_item_id: 商品ID
- quantity: 数量

### orders (订单表)
- id: 订单ID
- user_id: 用户ID
- total_points: 总积分
- shipping_address: 收货地址
- status: 订单状态
- created_at: 创建时间

### order_items (订单详情表)
- id: 订单项ID
- order_id: 订单ID
- shop_item_id: 商品ID
- shop_item_name: 商品名称(快照)
- quantity: 数量
- points_per_item: 单价(快照)

### users (用户表 - 新增字段)
- points: 用户积分余额
- address: 收货地址
- last_checkin_date: 最后签到日期

## 测试步骤

1. **启动后端服务**
   ```bash
   cd backend
   ./mvnw spring-boot:run
   ```

2. **启动用户前端**
   ```bash
   cd userPortal
   npm install
   npm start
   ```

3. **启动管理前端**
   ```bash
   cd web-portal
   npm install
   npm start
   ```

4. **测试流程**
   - 登录用户端
   - 在 Profile 页面进行签到(获得20积分)
   - 添加几条运动记录(每条获得50积分)
   - 访问 Shop 页面浏览商品
   - 将商品加入购物车
   - 在 Cart 页面调整数量并下单
   - 在管理端的 UserList 页面查看购买记录

## 注意事项

1. 每天只能签到一次
2. 下单时会检查积分是否充足
3. 下单时会检查商品库存是否充足
4. 下单成功后会自动扣除积分并减少商品库存
5. 订单创建后购物车会自动清空

## 初始化测试数据

建议在数据库中手动添加一些测试商品:
```sql
INSERT INTO shop_items (name, description, points_required, image_url, stock) VALUES
('运动水杯', '高品质运动水杯,容量500ml', 300, 'https://via.placeholder.com/300x200?text=Water+Bottle', 50),
('健身手环', '智能健身追踪手环', 400, 'https://via.placeholder.com/300x200?text=Fitness+Band', 30),
('瑜伽垫', '防滑瑜伽垫,适合各种运动', 350, 'https://via.placeholder.com/300x200?text=Yoga+Mat', 40);
```
