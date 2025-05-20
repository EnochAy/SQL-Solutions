/*Assessment_Q1.sql
High-Value Customers with Multiple Products

    This SQL query retrieves a list of customers who have both funded savings accounts and investment plans.
    It calculates the total deposits made by each customer and orders the results by total deposits in descending order.

*/
-- Find customers with both funded savings and investment plans
SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100.0, 2) AS total_deposits
FROM
    users_customuser u
LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id AND s.confirmed_amount > 0
LEFT JOIN plans_plan p ON p.owner_id = u.id AND p.plan_type_id = 1 AND p.amount > 0
WHERE
    EXISTS (
        SELECT 1 FROM savings_savingsaccount s1 
        WHERE s1.owner_id = u.id AND s1.confirmed_amount > 0
    )
    AND EXISTS (
        SELECT 1 FROM plans_plan p1 
        WHERE p1.owner_id = u.id AND p1.plan_type_id = 1 AND p1.amount > 0
    )
GROUP BY u.id, u.first_name, u.last_name
ORDER BY total_deposits DESC;



