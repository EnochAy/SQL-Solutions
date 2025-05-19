# Data Analytics SQL Assessment

## Overview
This repository contains my solutions for the SQL Proficiency Assessment aimed at analyzing customer behavior, account activity, and value estimation.

---

## Questions & Approaches

### Q1: High-Value Customers with Multiple Products
**Goal**: Identify customers who have both funded savings and investment plans.  
**Approach**: 
- Used `LEFT JOIN` to connect savings and plans.
- Ensured both types of products are funded.
- Aggregated and sorted by total deposits (converted from kobo to naira).

### Q2: Transaction Frequency Analysis
**Goal**: Segment customers by transaction frequency.  
**Approach**:
- Calculated monthly transactions per user.
- Averaged per user to get monthly activity.
- Categorized based on thresholds and aggregated.

### Q3: Account Inactivity Alert
**Goal**: Find active accounts with no inflow in the last year.  
**Approach**:
- Fetched last transaction per account.
- Filtered those older than 365 days.
- Tagged by type (Savings or Investment).

### Q4: Customer Lifetime Value (CLV)
**Goal**: Estimate CLV using transaction volume and tenure.  
**Approach**:
- Calculated tenure in months.
- Used CLV formula: `(transactions/tenure)*12*avg_profit`.
- Ensured data sanity with `NULLIF` and `COALESCE`.

---

## Challenges
- **Kobo Conversion**: All amounts were in kobo; needed to divide by 100.
- **Data Gaps**: Assumed presence of `transaction_date` and valid `date_joined`.
- **Edge Cases**: Guarded against zero division using `NULLIF`.

---

## How to Run
Each `.sql` file is standalone. Execute them on the provided schema using your SQL client or terminal.

---

## Repository Structure
