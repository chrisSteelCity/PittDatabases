# Database Test Data

## File in this directory

### `complete-test-data.sql` ✅
**Complete database backup with ALL data**

- **13 users** (including allen)
- **127 exercise records**
- All users password: `123`

---

## Quick Setup (Recommended)

From the project root directory:

```bash
./import-test-data.sh
```

That's it! The script will:
1. Create the database
2. Import all test data
3. Verify the import

---

## Manual Setup

If you prefer to do it manually:

```bash
# 1. Create database
mysql -u root -p
CREATE DATABASE exercise_tracker CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit;

# 2. Import data
mysql -u root -p exercise_tracker < backend/src/main/resources/db/complete-test-data.sql

# 3. Verify (should show: users=13, exercises=127)
mysql -u root -p exercise_tracker -e "SELECT COUNT(*) FROM users; SELECT COUNT(*) FROM exercises;"
```

---

## Test Users

All users have password: `123`

### Active Users (no alerts):
- allen
- sarah_smith
- emily_davis
- lisa_brown
- james_taylor
- chris_martin
- jennifer_lee

### Users with Alerts (>2 days inactive):
- john_doe (5 days)
- mike_johnson (8 days)
- david_wilson (3 days)
- amanda_white (3 days)

---

## Data Structure

### Users Table
- `id` (BIGINT, PK, auto-increment)
- `username` (VARCHAR(32), unique)
- `password_hash` (VARCHAR(100), BCrypt)
- `uuid` (VARCHAR(36), unique)

### Exercises Table
- `id` (BIGINT, PK, auto-increment)
- `user_id` (BIGINT, FK to users)
- `type` (ENUM: RUN, WALK, CYCLE, SWIM, GYM, OTHER)
- `duration_minutes` (INT, min 1)
- `location` (VARCHAR(128))
- `occurred_at` (DATETIME with timezone)
- `timezone` (VARCHAR(64), IANA timezone ID)

---

## Troubleshooting

### Error: "Table 'users' already exists"
The database already has tables. Either:
1. Drop and recreate: `DROP DATABASE exercise_tracker; CREATE DATABASE exercise_tracker;`
2. Or clear existing data: `DELETE FROM exercises; DELETE FROM users;`

Then re-import the SQL file.

### Error: "Unknown database 'exercise_tracker'"
You need to create the database first (see Step 1 above).

---

**Note**: The `complete-test-data.sql` file contains the exact same data you have in your local database right now. It will be uploaded to GitHub and can be imported on any new machine.
