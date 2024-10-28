-- Queries for Data Exploration
-- Retrieve all customer information
SELECT * FROM customers;

-- Query accounts for a specific customer
SELECT * FROM accounts WHERE customer_id = 1; -- Change 1 to the desired customer_id

-- Find the customer name and account balance for each account
SELECT c.first_name, c.last_name, a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;

-- Analyze customer loan balances
SELECT c.first_name, c.last_name, l.loan_amount
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id;

-- List all customers who have made a transaction in March 2024
SELECT DISTINCT c.first_name, c.last_name
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_date BETWEEN '2024-03-01' AND '2024-03-31';
