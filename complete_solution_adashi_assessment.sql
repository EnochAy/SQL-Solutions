SHOW DATABASES;

USE adashi_assessment;
SHOW TABLES;
SELECT COUNT(*) FROM plans_plan;
SELECT * FROM plans_plan LIMIT 5;

USE adashi_assessment;
SHOW TABLES;
SELECT COUNT(*) FROM plans_plan;
SELECT id, name, amount FROM plans_plan LIMIT 5;
SELECT COUNT(*) FROM savings_savingsaccount WHERE transaction_status = 'success';

/* Assessment_Q1.sql
High-Value Customers with Multiple Products
    This SQL query retrieves a list of customers who have both funded savings accounts and investment plans.
    It calculates the total deposits made by each customer and orders the results by total deposits in descending order.
*/

SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100.0, 2) AS total_deposits
FROM
    users_customuser u
INNER JOIN plans_plan p ON p.owner_id = u.id AND p.plan_type_id = 1 AND p.amount > 0
INNER JOIN savings_savingsaccount s ON s.savings_id = p.id AND s.confirmed_amount > 0 AND s.is_regular_savings = 1 AND s.transaction_status = 'success'
GROUP BY u.id, u.first_name, u.last_name
HAVING
    COUNT(DISTINCT s.id) > 0 AND COUNT(DISTINCT p.id) > 0
ORDER BY total_deposits DESC;


-- Add index:
CREATE INDEX idx_savings ON savings_savingsaccount(savings_id, confirmed_amount, is_regular_savings);
CREATE INDEX idx_plans ON plans_plan(owner_id, plan_type_id, amount);



/* Assessment_Q2.sql
Transaction Frequency Analysis
    This SQL query retrieves a list of customers who have both funded savings accounts and investment plans.
    It calculates the total deposits made by each customer and orders the results by total deposits in descending order.
*/

-- Classify customers based on transaction frequency
WITH txn_counts AS (
    SELECT
        savings_id AS owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m-01') AS txn_month,
        COUNT(*) AS monthly_txn
    FROM
        savings_savingsaccount
    GROUP BY savings_id, DATE_FORMAT(transaction_date, '%Y-%m-01')
),
monthly_avg AS (
    SELECT
        owner_id,
        AVG(monthly_txn) AS avg_txn_per_month
    FROM txn_counts
    GROUP BY owner_id
),
classified AS (
    SELECT
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM monthly_avg
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM classified
GROUP BY frequency_category;



/* Assessment_Q3.sql
Account Inactivity Alert
    This SQL query retrieves a list of customers who have both funded savings accounts and investment plans.
    It calculates the total deposits made by each customer and orders the results by total deposits in descending order.
*/

-- Find accounts (savings or investment) with no transaction in last 365 days
WITH last_txn_dates AS (
    SELECT
        id AS plan_id,
        savings_id AS owner_id,
        'Savings' AS type,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY id, savings_id
    UNION
    SELECT
        id AS plan_id,
        owner_id,
        'Investment' AS type,
        MAX(last_charge_date) AS last_transaction_date
    FROM plans_plan
    WHERE plan_type_id = 1
    GROUP BY id, owner_id
)
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM last_txn_dates
WHERE last_transaction_date < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
ORDER BY inactivity_days DESC;


/* Assessment_Q4.sql
Customer Lifetime Value (CLV) Estimation
    This SQL query retrieves a list of customers who have both funded savings accounts and investment plans.
    It calculates the total deposits made by each customer and orders the results by total deposits in descending order.
*/

-- Estimate CLV based on transaction volume and tenure
WITH user_txns AS (
    SELECT
        s.savings_id AS plan_id,
        p.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) AS total_value
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.savings_id = p.id
    GROUP BY s.savings_id, p.owner_id
),
tenure_calc AS (
    SELECT
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT
        t.customer_id,
        t.name,
        t.tenure_months,
        COALESCE(u.total_transactions, 0) AS total_transactions,
        ROUND(
            (COALESCE(u.total_transactions / NULLIF(t.tenure_months, 0), 0)) * 12 * 
            (COALESCE(u.total_value, 0) * 0.001 / NULLIF(u.total_transactions, 0)),
            2
        ) AS estimated_clv
    FROM tenure_calc t
    LEFT JOIN user_txns u ON u.owner_id = t.customer_id
)
SELECT * 
FROM clv_calc
WHERE estimated_clv IS NOT NULL
ORDER BY estimated_clv DESC;