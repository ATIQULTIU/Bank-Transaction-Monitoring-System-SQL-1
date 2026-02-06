-- ============================================
-- Bank Transaction Monitoring System (SQLite)
-- One-Run SQL Project
-- Author: MD ATIQUL ISLAM (Atik)
-- ============================================

PRAGMA foreign_keys = ON;

-- Drop tables if they exist
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;

-- Branches Table
CREATE TABLE branches (
    branch_id INTEGER PRIMARY KEY AUTOINCREMENT,
    branch_name TEXT NOT NULL,
    location TEXT
);

-- Customers Table
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_name TEXT NOT NULL,
    phone TEXT,
    email TEXT UNIQUE,
    address TEXT
);

-- Accounts Table
CREATE TABLE accounts (
    account_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    branch_id INTEGER NOT NULL,
    account_type TEXT CHECK(account_type IN ('Savings','Current')),
    balance REAL DEFAULT 0,
    status TEXT DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- Transactions Table
CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id INTEGER NOT NULL,
    transaction_type TEXT CHECK(transaction_type IN ('Deposit','Withdrawal','Transfer')),
    amount REAL NOT NULL,
    transaction_date DATE DEFAULT (DATE('now')),
    description TEXT,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Insert Branches
INSERT INTO branches (branch_name, location) VALUES
('Dhaka Main Branch', 'Dhaka'),
('Chittagong Branch', 'Chittagong');

-- Insert Customers
INSERT INTO customers (customer_name, phone, email, address) VALUES
('Atik Islam', '01700000000', 'atik@email.com', 'Dhaka'),
('Rahim Uddin', '01800000000', 'rahim@email.com', 'Chittagong');

-- Insert Accounts
INSERT INTO accounts (customer_id, branch_id, account_type, balance) VALUES
(1, 1, 'Savings', 50000),
(2, 2, 'Current', 30000);

-- Deposit Transaction
INSERT INTO transactions (account_id, transaction_type, amount, description)
VALUES (1, 'Deposit', 10000, 'Salary Deposit');

UPDATE accounts
SET balance = balance + 10000
WHERE account_id = 1;

-- Withdrawal Transaction
INSERT INTO transactions (account_id, transaction_type, amount, description)
VALUES (2, 'Withdrawal', 5000, 'ATM Withdrawal');

UPDATE accounts
SET balance = balance - 5000
WHERE account_id = 2;

-- View All Transactions
SELECT 
    t.transaction_id,
    c.customer_name,
    a.account_type,
    t.transaction_type,
    t.amount,
    t.transaction_date,
    t.description
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id;

-- Monitor Large Transactions (Above 20,000)
SELECT 
    transaction_id,
    account_id,
    transaction_type,
    amount,
    transaction_date
FROM transactions
WHERE amount > 20000;

-- Customer Account Summary
SELECT 
    c.customer_name,
    a.account_type,
    a.balance,
    b.branch_name
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
JOIN branches b ON a.branch_id = b.branch_id;

-- Daily Transaction Summary
SELECT transaction_date, COUNT(*) AS total_transactions, SUM(amount) AS total_amount
FROM transactions
GROUP BY transaction_date;

-- View Tables
SELECT * FROM branches;
SELECT * FROM customers;
SELECT * FROM accounts;
SELECT * FROM transactions;
