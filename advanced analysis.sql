-- Create a view of active loans with payments greater than $1000
CREATE VIEW ActiveLoans AS
SELECT l.loan_id, c.first_name, c.last_name, l.loan_amount
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
WHERE l.loan_id IN (SELECT loan_id FROM loan_payments WHERE payment_amount > 1000);

-- Create an index on transaction_date in the transactions table for performance optimization
CREATE INDEX idx_transaction_date ON transactions(transaction_date);