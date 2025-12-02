#!/bin/bash

# Exercise Tracker - Import Test Data Script
# This script automatically sets up the database with test data

echo "=========================================="
echo "Exercise Tracker - Database Setup"
echo "=========================================="
echo ""

# Check if MySQL is running
if ! command -v mysql &> /dev/null; then
    echo "❌ MySQL is not installed or not in PATH"
    exit 1
fi

# Database credentials (you may need to modify these)
DB_USER="root"
DB_NAME="exercise_tracker"

echo "Step 1: Creating database..."
mysql -u $DB_USER -p -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

if [ $? -eq 0 ]; then
    echo "✓ Database created/verified"
else
    echo "❌ Failed to create database"
    exit 1
fi

echo ""
echo "Step 2: Importing test data..."
mysql -u $DB_USER -p $DB_NAME < backend/src/main/resources/db/complete-test-data.sql

if [ $? -eq 0 ]; then
    echo "✓ Test data imported successfully"
else
    echo "❌ Failed to import test data"
    exit 1
fi

echo ""
echo "Step 3: Verifying data..."
mysql -u $DB_USER -p $DB_NAME -e "
SELECT 'Users:' as '', COUNT(*) as count FROM users
UNION ALL
SELECT 'Exercises:', COUNT(*) FROM exercises;
"

echo ""
echo "=========================================="
echo "✓ Setup Complete!"
echo "=========================================="
echo ""
echo "Test Login:"
echo "  Username: allen"
echo "  Password: 123"
echo ""
echo "All users have password: 123"
echo ""
