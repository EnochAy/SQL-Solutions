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