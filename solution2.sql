
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