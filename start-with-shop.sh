#!/bin/bash

echo "================================"
echo "启动 Exercise Tracker 完整系统"
echo "================================"
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}步骤 1/4: 启动后端服务...${NC}"
echo "========================================="
cd backend

# 检查Java版本
if ! command -v java &> /dev/null; then
    echo -e "${RED}错误: 未找到Java,请先安装Java 17或更高版本${NC}"
    exit 1
fi

# 启动后端
echo "正在启动Spring Boot后端..."
./mvnw spring-boot:run > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
echo -e "${GREEN}后端已启动! PID: $BACKEND_PID${NC}"
echo "后端日志: logs/backend.log"
echo "后端地址: http://localhost:8080"
echo ""

# 等待后端启动
echo "等待后端启动完成(约30秒)..."
sleep 30

cd "$SCRIPT_DIR"

echo -e "${BLUE}步骤 2/4: 初始化测试数据...${NC}"
echo "========================================="
echo -e "${YELLOW}请按照以下步骤手动初始化数据:${NC}"
echo "1. 打开数据库管理工具(如DBeaver、MySQL Workbench等)"
echo "2. 连接到数据库"
echo "3. 执行脚本: backend/init-shop-data.sql"
echo ""
echo -e "${YELLOW}测试账号信息:${NC}"
echo "如果数据库中已有用户,可以直接使用"
echo "如果没有,请先通过用户端注册一个账号"
echo ""
read -p "按Enter键继续启动前端服务..."

echo ""
echo -e "${BLUE}步骤 3/4: 启动用户前端 (userPortal)...${NC}"
echo "========================================="
cd userPortal

# 检查node_modules
if [ ! -d "node_modules" ]; then
    echo "首次运行,正在安装依赖..."
    npm install
fi

# 启动userPortal
echo "正在启动用户前端..."
npm start > ../logs/userportal.log 2>&1 &
USERPORTAL_PID=$!
echo -e "${GREEN}用户前端已启动! PID: $USERPORTAL_PID${NC}"
echo "用户前端日志: logs/userportal.log"
echo "用户前端地址: http://localhost:8100"
echo ""

cd "$SCRIPT_DIR"

echo -e "${BLUE}步骤 4/4: 启动管理前端 (webPortal)...${NC}"
echo "========================================="
cd web-portal

# 检查node_modules
if [ ! -d "node_modules" ]; then
    echo "首次运行,正在安装依赖..."
    npm install
fi

# 启动webPortal
echo "正在启动管理前端..."
npm start > ../logs/webportal.log 2>&1 &
WEBPORTAL_PID=$!
echo -e "${GREEN}管理前端已启动! PID: $WEBPORTAL_PID${NC}"
echo "管理前端日志: logs/webportal.log"
echo "管理前端地址: http://localhost:4200"
echo ""

cd "$SCRIPT_DIR"

echo ""
echo "================================"
echo -e "${GREEN}所有服务已启动完成!${NC}"
echo "================================"
echo ""
echo "服务访问地址:"
echo "  - 后端API:    http://localhost:8080"
echo "  - 用户前端:   http://localhost:8100"
echo "  - 管理前端:   http://localhost:4200"
echo ""
echo "进程ID:"
echo "  - 后端 PID:      $BACKEND_PID"
echo "  - 用户前端 PID:  $USERPORTAL_PID"
echo "  - 管理前端 PID:  $WEBPORTAL_PID"
echo ""
echo "日志文件位置:"
echo "  - 后端:   logs/backend.log"
echo "  - 用户:   logs/userportal.log"
echo "  - 管理:   logs/webportal.log"
echo ""
echo -e "${YELLOW}测试账号(需要先注册):${NC}"
echo "  用户名: testuser"
echo "  密码:   Test123456"
echo ""
echo -e "${YELLOW}初始积分获取方式:${NC}"
echo "  1. 在Profile页面每日签到: +20积分"
echo "  2. 添加运动记录: +50积分/次"
echo ""
echo -e "${YELLOW}停止服务:${NC}"
echo "  执行: kill $BACKEND_PID $USERPORTAL_PID $WEBPORTAL_PID"
echo "  或者: ./stop-all.sh"
echo ""
echo "按 Ctrl+C 退出此脚本不会停止服务"
echo ""

# 保存PID到文件
echo "$BACKEND_PID" > logs/backend.pid
echo "$USERPORTAL_PID" > logs/userportal.pid
echo "$WEBPORTAL_PID" > logs/webportal.pid

# 等待用户输入
read -p "按Enter键退出..."
