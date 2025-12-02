# 系统启动成功!

## ✅ 所有服务已成功启动

### 服务访问地址

| 服务 | 地址 | 说明 |
|------|------|------|
| 后端API | http://localhost:8080 | Spring Boot后端服务 |
| 用户前端 | http://localhost:8100 | 用户端(userPortal) - Angular/Ionic |
| 管理前端 | http://localhost:4200 | 管理端(webPortal) - Angular |

## 📋 下一步操作

### 1. 初始化测试数据

**重要!** 需要先添加测试商品数据:

```bash
# 连接到你的数据库,执行以下SQL脚本:
# 文件位置: /Users/allen/Downloads/exercise-tracker-main/backend/init-shop-data.sql
```

或使用数据库管理工具(如DBeaver)执行:

```sql
INSERT INTO shop_items (name, description, points_required, image_url, stock) VALUES
('高级运动水杯', '不锈钢保温运动水杯,容量750ml,保温12小时', 300, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&h=300&fit=crop', 100),
('智能健身手环', '支持心率监测、睡眠追踪、运动记录的智能手环', 400, 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=400&h=300&fit=crop', 50),
('专业瑜伽垫', '10mm加厚防滑瑜伽垫,环保材质,适合各种运动', 350, 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=400&h=300&fit=crop', 80),
('运动背包', '30L大容量运动背包,防水透气,多隔层设计', 320, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=300&fit=crop', 60),
('蛋白粉补剂', '高品质乳清蛋白粉,增肌必备,香草口味2磅装', 380, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=400&h=300&fit=crop', 45),
('运动毛巾', '速干吸汗运动毛巾,抗菌材质,附收纳袋', 280, 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=400&h=300&fit=crop', 120),
('跑步臂包', '防水跑步手机臂包,适配6.5英寸以下手机', 290, 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&h=300&fit=crop', 90),
('健身手套', '防滑透气健身手套,护腕加长设计', 310, 'https://images.unsplash.com/photo-1598289431512-b97b0917affc?w=400&h=300&fit=crop', 70);
```

### 2. 创建测试账号

打开用户前端: http://localhost:8100

**注册新账号:**
- 用户名: `testuser`
- 密码: `Test123456`

或使用任意你喜欢的用户名和密码(密码至少6位)

### 3. 获取初始积分

登录后:

1. **每日签到 (+20积分)**
   - 点击底部 "Profile" 标签
   - 点击 "Check in (+20 points)" 按钮

2. **添加运动记录 (+50积分/次)**
   - 点击底部 "Add" 标签
   - 填写运动信息并保存
   - 建议添加7-8条记录,累积350-400积分

### 4. 开始购物!

1. 点击 "Shop" 标签浏览商品
2. 点击 "Add to Cart" 加入购物车
3. 点击 "Cart" 标签查看购物车
4. 调整数量,点击 "Checkout" 下单

### 5. 查看订单记录(管理端)

1. 访问管理端: http://localhost:4200
2. 使用coach账号登录(如果有)
3. 点击某个用户查看详情
4. 向下滚动到 "Purchase History" 部分

## 🛑 停止服务

### 方式一: 使用脚本
```bash
cd /Users/allen/Downloads/exercise-tracker-main
./stop-all-services.sh
```

### 方式二: 手动停止
```bash
# 查找进程
ps aux | grep -E "spring-boot|ng serve"

# 停止进程
kill <PID>

# 或一次性停止所有
lsof -ti :8080,:8100,:4200 | xargs kill -9
```

## 📊 功能列表

### 用户端功能
- ✅ 用户注册/登录
- ✅ 添加运动记录(+50积分)
- ✅ 查看运动历史
- ✅ 每日签到(+20积分)
- ✅ 浏览商品
- ✅ 购物车管理
- ✅ 积分兑换下单
- ✅ 个人资料管理
- ✅ 收货地址设置

### 管理端功能
- ✅ 查看用户列表
- ✅ 查看用户运动记录
- ✅ 查看用户购买记录
- ✅ 7天运动数据图表

### 积分系统
- 签到: 20积分/天
- 运动记录: 50积分/次
- 商品价格: 280-400积分

## 📁 项目文件

| 文件 | 说明 |
|------|------|
| `backend/init-shop-data.sql` | 商品测试数据SQL脚本 |
| `SHOP_SYSTEM_README.md` | 商城系统功能详细说明 |
| `TESTING_GUIDE.md` | 完整测试指南 |
| `start-with-shop.sh` | 自动启动脚本 |
| `stop-all-services.sh` | 停止所有服务脚本 |
| `logs/` | 日志文件目录 |

## 🐛 常见问题

### 端口被占用
```bash
# 释放端口
lsof -ti :8080 | xargs kill -9  # 后端
lsof -ti :8100 | xargs kill -9  # 用户前端
lsof -ti :4200 | xargs kill -9  # 管理前端
```

### 前端无法连接后端
1. 确认后端已启动: http://localhost:8080
2. 检查浏览器控制台是否有CORS错误
3. 检查API地址配置

### 数据库连接失败
检查 `backend/src/main/resources/application.properties` 中的数据库配置

## 📝 测试流程建议

1. 注册账号 → 2. 签到获得20积分 → 3. 添加8条运动记录获得400积分 →
4. 浏览商品 → 5. 加入购物车 → 6. 下单 → 7. 在管理端查看订单

## ✨ 享受你的新功能吧!

所有功能已完全实现并运行中。祝测试愉快! 🎉
