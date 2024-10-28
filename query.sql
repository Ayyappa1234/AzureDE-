
-- Create tables for CustomerAccountLoanDB

-- Customer Feed
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    zip VARCHAR(20)
);

-- Account Feed
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(50),
    balance DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Transaction Feed
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_date DATE,
    transaction_amount DECIMAL(10, 2),
    transaction_type VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Loan Feed
CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_amount DECIMAL(10, 2),
    interest_rate DECIMAL(5, 2),
    loan_term INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Loan Payment Feed
CREATE TABLE loan_payments (
    payment_id INT PRIMARY KEY,
    loan_id INT,
    payment_date DATE,
    payment_amount DECIMAL(10, 2),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- Insert sample data into customers
INSERT INTO customers (customer_id, first_name, last_name, address, city, state, zip) VALUES
(1, 'John', 'Doe', '123 Elm St', 'Springfield', 'IL', '62701'),
(2, 'Jane', 'Smith', '456 Oak St', 'Springfield', 'IL', '62701');

-- Insert sample data into accounts
INSERT INTO accounts (account_id, customer_id, account_type, balance) VALUES
(1, 1, 'Checking', 1500.00),
(2, 1, 'Savings', 2500.00),
(3, 2, 'Checking', 3000.00);

-- Insert sample data into transactions
INSERT INTO transactions (transaction_id, account_id, transaction_date, transaction_amount, transaction_type) VALUES
(1, 1, '2024-03-15', 100.00, 'Deposit'),
(2, 1, '2024-03-16', 50.00, 'Withdrawal');

-- Insert sample data into loans
INSERT INTO loans (loan_id, customer_id, loan_amount, interest_rate, loan_term) VALUES
(1, 1, 10000.00, 5.00, 24),
(2, 2, 15000.00, 4.50, 36);

-- Insert sample data into loan_payments
INSERT INTO loan_payments (payment_id, loan_id, payment_date, payment_amount) VALUES
(1, 1, '2024-01-15', 500.00),
(2, 1, '2024-02-15', 500.00);

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
LIMIT 1;  -- For PostgreSQL; for SQL Server use TOP 1

-- Analyze transactions by account and transaction type
SELECT a.account_id, t.transaction_type, SUM(t.transaction_amount) AS total_transaction_amount
FROM accounts a
JOIN transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, t.transaction_type;

-- Advanced Analysis
-- Create a view of active loans with payments greater than $1000
CREATE VIEW ActiveLoans AS
SELECT l.loan_id, c.first_name, c.last_name, l.loan_amount
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
WHERE l.loan_id IN (SELECT loan_id FROM loan_payments WHERE payment_amount > 1000);

-- Create an index on transaction_date in the transactions table for performance optimization
CREATE INDEX idx_transaction_date ON transactions(transaction_date);
