-- Aggregation and Insights
-- Calculate the total balance across all accounts for each customer
SELECT c.customer_id, c.first_name, c.last_name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Calculate the average loan amount for each loan term
SELECT loan_term, AVG(loan_amount) AS average_loan_amount
FROM loans
GROUP BY loan_term;

-- Find the total loan amount and interest across all loans
SELECT SUM(loan_amount) AS total_loan_amount, SUM(loan_amount * interest_rate / 100) AS total_interest
FROM loans;

-- Find the most frequent transaction type
SELECT transaction_type, COUNT(*) AS frequency
FROM transactions
GROUP BY transaction_type
ORDER BY frequency DESC
LIMIT 1;

-- Analyze transactions by account and transaction type
SELECT a.account_id, t.transaction_type, SUM(t.transaction_amount) AS total_transaction_amount
FROM accounts a
JOIN transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, t.transaction_type;

