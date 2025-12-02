#!/bin/bash

# Exercise Tracker - One-Click Start Script
# Cross-platform script for macOS, Linux, and Windows (Git Bash)

echo "=========================================="
echo "Exercise Tracker - Starting All Services"
echo "=========================================="
echo ""

# Function to open URL in default browser (cross-platform)
open_browser() {
    local url=$1
    if command -v xdg-open > /dev/null; then
        # Linux
        xdg-open "$url" 2>/dev/null
    elif command -v open > /dev/null; then
        # macOS
        open "$url"
    elif command -v start > /dev/null; then
        # Windows (Git Bash)
        start "$url" 2>/dev/null
    else
        echo "Please open: $url"
    fi
}

# Check if MySQL is running and setup database
echo "⏳ Checking MySQL..."
if command -v mysql > /dev/null; then
    echo "✓ MySQL client found"

    # Check if database exists
    echo "⏳ Checking database..."
    DB_EXISTS=$(mysql -u root -proot -e "SHOW DATABASES LIKE 'exercise_tracker';" 2>/dev/null | grep exercise_tracker)

    if [ -z "$DB_EXISTS" ]; then
        echo "📦 Database not found. Running setup..."
        ./import-test-data.sh
    else
        # Check if data exists
        RECORD_COUNT=$(mysql -u root -proot exercise_tracker -e "SELECT COUNT(*) as count FROM exercises;" 2>/dev/null | tail -1)
        if [ "$RECORD_COUNT" -lt "10" ]; then
            echo "📦 Database exists but no data. Importing test data..."
            mysql -u root -proot exercise_tracker < backend/src/main/resources/db/complete-test-data.sql 2>/dev/null
            echo "✓ Test data imported"
        else
            echo "✓ Database ready with $RECORD_COUNT exercise records"
        fi
    fi
else
    echo "⚠ MySQL client not found. Please ensure MySQL is installed and running."
    exit 1
fi

echo ""

# Check and install dependencies
echo "⏳ Checking dependencies..."

# UserPortal dependencies
if [ ! -d "userPortal/node_modules" ]; then
    echo "📦 Installing UserPortal dependencies..."
    cd userPortal
    npm install
    cd ..
else
    echo "✓ UserPortal dependencies installed"
fi

# Web-Portal dependencies
if [ ! -d "web-portal/node_modules" ]; then
    echo "📦 Installing Web-Portal dependencies..."
    cd web-portal
    npm install
    cd ..
else
    echo "✓ Web-Portal dependencies installed"
fi

echo ""
echo "Starting services in background..."
echo "Press Ctrl+C to stop all services"
echo ""

# Create logs directory
mkdir -p logs

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "=========================================="
    echo "Stopping all services..."
    echo "=========================================="

    # Kill background jobs
    jobs -p | xargs kill 2>/dev/null

    echo ""
    echo "✓ All services stopped"
    exit 0
}

# Trap Ctrl+C
trap cleanup INT TERM

# 1. Start Backend
echo "[1/3] Starting Backend (Spring Boot)..."
cd backend
./mvnw spring-boot:run > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
cd ..

# Wait for backend
echo "⏳ Waiting for backend (this may take 30-60 seconds)..."
for i in {1..60}; do
    if curl -s http://localhost:8080 > /dev/null 2>&1; then
        echo "✓ Backend started on http://localhost:8080"
        break
    fi
    sleep 2
done

echo ""

# 2. Start UserPortal
echo "[2/3] Starting UserPortal (Ionic)..."
cd userPortal
npm run start -- --port 8100 > ../logs/userportal.log 2>&1 &
cd ..

echo "⏳ Waiting for UserPortal..."
for i in {1..30}; do
    if curl -s http://localhost:8100 > /dev/null 2>&1; then
        echo "✓ UserPortal started on http://localhost:8100"
        break
    fi
    sleep 2
done

echo ""

# 3. Start Web-Portal
echo "[3/3] Starting Web-Portal (Angular)..."
cd web-portal
ng serve --port 4201 --open=false > ../logs/webportal.log 2>&1 &
cd ..

echo "⏳ Waiting for Web-Portal..."
for i in {1..30}; do
    if curl -s http://localhost:4201 > /dev/null 2>&1; then
        echo "✓ Web-Portal started on http://localhost:4201"
        break
    fi
    sleep 2
done

echo ""
echo "=========================================="
echo "✓ All services started successfully!"
echo "=========================================="
echo ""
echo "Services:"
echo "  • Backend:     http://localhost:8080"
echo "  • UserPortal:  http://localhost:8100/auth"
echo "  • Web-Portal:  http://localhost:4201"
echo ""
echo "Logs: logs/ directory"
echo ""
echo "=========================================="
echo "Test Login:"
echo "  Username: allen"
echo "  Password: 123"
echo "=========================================="
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Keep running
wait
