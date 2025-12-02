# Test Data Information

## Overview
The database has been populated with test data for demonstration purposes.

## Test Users

**All users password: `123`**

### User List (10 users)

| ID | Username | Activity Level | Days Since Last Exercise | Alert Status |
|----|----------|----------------|--------------------------|--------------|
| 4 | john_doe | Moderate | 5 days | ⚠️ ALERT |
| 5 | sarah_smith | Active | 1 day | ✓ Active |
| 6 | mike_johnson | Inactive | 8 days | ⚠️ ALERT |
| 7 | emily_davis | Active | 1 day | ✓ Active |
| 8 | david_wilson | Moderate | 3 days | ⚠️ ALERT |
| 9 | lisa_brown | Active | 1 day | ✓ Active |
| 10 | james_taylor | Active | 1 day | ✓ Active |
| 11 | amanda_white | Inactive | 3 days | ⚠️ ALERT |
| 12 | chris_martin | Active | 1 day | ✓ Active |
| 13 | jennifer_lee | Moderate | 1 day | ✓ Active |

## Data Statistics

- **Total Users**: 10
- **Total Exercise Records**: 81 records
- **Users with Alerts** (>2 days inactive): 4 users
  - john_doe (5 days)
  - mike_johnson (8 days)
  - david_wilson (3 days)
  - amanda_white (3 days)

## Exercise Data Distribution

Each user has exercise records spanning the last 7-14 days with different activity patterns:

- **Very Active Users**: Exercise almost every day
- **Active Users**: Exercise 4-6 days per week
- **Moderate Users**: Exercise 2-3 days per week
- **Inactive Users**: Last exercise 3+ days ago (triggers alert)

## How to Use Test Data

### For UserPortal (Mobile App)
Login with any username above with password `123`.

Example:
- Username: `sarah_smith`
- Password: `123`

### For Web-Portal (Coach Dashboard)
1. Login as a coach (register a new coach account)
2. View the user list dashboard
3. Users with ⚠️ will show up with alert badges
4. Click on any user to see their exercise history and 7-day chart

## Demonstrating Features

### 1. Alert System
- Users with **>2 days** since last exercise show ⚠️ alert
- Best examples: `mike_johnson` (8 days), `john_doe` (5 days)

### 2. Data Visualization
- All users have 7+ days of data for meaningful charts
- Best example for charts: `sarah_smith`, `chris_martin` (consistent activity)

### 3. Timezone Support
- Users are distributed across different timezones:
  - US: New York, Los Angeles, Chicago, Denver
  - Europe: Paris
  - Asia: Hong Kong

## SQL Location

Test data script: `/backend/src/main/resources/db/test-data.sql`

## Re-generating Data

If you need to reset the data:

```bash
# Clear existing data (careful!)
mysql -u root -p exercise_tracker -e "DELETE FROM exercises WHERE user_id > 3; DELETE FROM users WHERE id > 3;"

# Re-import test data
mysql -u root -p exercise_tracker < backend/src/main/resources/db/test-data.sql
```

---

**Note**: This test data is for demonstration purposes only. It simulates realistic usage patterns for the exercise tracking application.
