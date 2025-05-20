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