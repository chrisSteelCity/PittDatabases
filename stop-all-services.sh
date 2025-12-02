#!/bin/bash

echo "停止所有服务..."

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 从PID文件读取进程ID
if [ -f "logs/backend.pid" ]; then
    BACKEND_PID=$(cat logs/backend.pid)
    if ps -p $BACKEND_PID > /dev/null 2>&1; then
        echo -e "${YELLOW}停止后端服务 (PID: $BACKEND_PID)...${NC}"
        kill $BACKEND_PID
        echo -e "${GREEN}后端服务已停止${NC}"
    else
        echo "后端服务未运行"
    fi
    rm logs/backend.pid
fi

if [ -f "logs/userportal.pid" ]; then
    USERPORTAL_PID=$(cat logs/userportal.pid)
    if ps -p $USERPORTAL_PID > /dev/null 2>&1; then
        echo -e "${YELLOW}停止用户前端 (PID: $USERPORTAL_PID)...${NC}"
        kill $USERPORTAL_PID
        echo -e "${GREEN}用户前端已停止${NC}"
    else
        echo "用户前端未运行"
    fi
    rm logs/userportal.pid
fi

if [ -f "logs/webportal.pid" ]; then
    WEBPORTAL_PID=$(cat logs/webportal.pid)
    if ps -p $WEBPORTAL_PID > /dev/null 2>&1; then
        echo -e "${YELLOW}停止管理前端 (PID: $WEBPORTAL_PID)...${NC}"
        kill $WEBPORTAL_PID
        echo -e "${GREEN}管理前端已停止${NC}"
    else
        echo "管理前端未运行"
    fi
    rm logs/webportal.pid
fi

# 额外清理: 查找并停止可能遗留的进程
echo ""
echo "检查是否有遗留进程..."

# 查找Spring Boot进程
SPRING_PIDS=$(ps aux | grep "spring-boot:run" | grep -v grep | awk '{print $2}')
if [ ! -z "$SPRING_PIDS" ]; then
    echo "发现Spring Boot进程: $SPRING_PIDS"
    echo $SPRING_PIDS | xargs kill
fi

# 查找npm start进程(userPortal和webPortal)
NPM_PIDS=$(ps aux | grep "npm start" | grep -v grep | awk '{print $2}')
if [ ! -z "$NPM_PIDS" ]; then
    echo "发现npm进程: $NPM_PIDS"
    echo $NPM_PIDS | xargs kill
fi

# 查找Angular和Ionic进程
NG_PIDS=$(ps aux | grep -E "ng serve|ionic serve" | grep -v grep | awk '{print $2}')
if [ ! -z "$NG_PIDS" ]; then
    echo "发现Angular/Ionic进程: $NG_PIDS"
    echo $NG_PIDS | xargs kill
fi

echo ""
echo -e "${GREEN}所有服务已停止!${NC}"
