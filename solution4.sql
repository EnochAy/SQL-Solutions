/* Assessment_Q4.sql
Customer Lifetime Value (CLV) Estimation
    This SQL query retrieves a list of customers who have both funded savings accounts and investment plans.
    It calculates the total deposits made by each customer and orders the results by total deposits in descending order.
*/



-- Estimate CLV based on transaction volume and tenure
WITH user_txns AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) AS total_value
    FROM savings_savingsaccount
    GROUP BY owner_id
),
tenure_calc AS (
    SELECT
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        DATE_PART('month', AGE(CURRENT_DATE, date_joined)) AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT
        t.customer_id,
        t.name,
        t.tenure_months,
        COALESCE(u.total_transactions, 0) AS total_transactions,
        ROUND(
            (COALESCE(u.total_transactions::numeric / NULLIF(t.tenure_months, 0), 0)) * 12 * 
            (COALESCE(u.total_value, 0) * 0.001 / NULLIF(u.total_transactions, 0)),
            2
        ) AS estimated_clv
    FROM tenure_calc t
    LEFT JOIN user_txns u ON u.owner_id = t.customer_id
)
SELECT * 
FROM clv_calc
ORDER BY estimated_clv DESC;
