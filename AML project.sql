-- Anti Money Laundering (AML)
CREATE DATABASE antimoneylaundering_db;
USE antimoneylaundering_db;
CREATE TABLE aml_transactions (
    Time VARCHAR(10),
    Date DATE,
    Sender_account BIGINT,
    Receiver_account BIGINT,
    Amount DECIMAL(15,2),
    Payment_currency VARCHAR(50),
    Received_currency VARCHAR(50),
    Sender_bank_location VARCHAR(50),
    Receiver_bank_location VARCHAR(50),
    Payment_type VARCHAR(50),
    Is_laundering INT,
    Laundering_type VARCHAR(100)
);
SELECT * FROM aml_transactions;
-- How many total transactions?
SELECT count(*) FROM aml_transactions;
-- How many unique customers?
SELECT count(DISTINCT Sender_account, Receiver_account) FROM aml_transactions;
-- NULL VALUES OF MISSING values
SELECT COUNT(*) FROM aml_transactions 
WHERE date IS NULL
   OR Sender_account IS NULL
   OR Receiver_account IS NULL
   OR amount IS NULL;
-- High Risk value transaction
SELECT date,sender_account,amount,'High Value Transaction' AS risk_flag
FROM aml_transactions WHERE amount >= 1000;
-- Date Range of Transactions
SELECT MIN(Date) AS Start_Date,
       MAX(Date) AS End_Date FROM aml_transactions;
-- Total Transaction Volume
SELECT SUM(Amount) AS Total_Volume FROM aml_transactions;
-- Average Transaction Amount
SELECT AVG(Amount) FROM aml_transactions;
-- Top 10 Highest Transactions
SELECT * FROM aml_transactions ORDER BY amount DESC LIMIT 10;
-- Transactions by Payment Type
SELECT Payment_type, COUNT(*) AS total_txn FROM aml_transactions GROUP BY Payment_type;
-- Transactions by Currency
SELECT Payment_currency, COUNT(*) FROM aml_transactions GROUP BY Payment_currency;
-- Transactions by Bank Location
SELECT Sender_bank_location, COUNT(*) FROM aml_transactions GROUP BY Sender_bank_location;
-- Cross-Border Transactions
SELECT COUNT(*) FROM aml_transactions WHERE Sender_bank_location <> Receiver_bank_location;
-- How many transactions are flagged as laundering?
SELECT Is_laundering, COUNT(*) FROM aml_transactions GROUP BY Is_laundering;
-- High-Risk Account Detection
-- Accounts with most suspicious activity
SELECT Sender_account, COUNT(*) AS suspicious_count FROM aml_transactions
WHERE Is_laundering = 1 GROUP BY Sender_account ORDER BY suspicious_count DESC;
-- Accounts sending high total amount
SELECT Sender_account, SUM(Amount) AS total_sent FROM aml_transactions GROUP BY Sender_account
ORDER BY total_sent DESC LIMIT 10;
-- Rapid Movement of Funds
SELECT Sender_account, Date, COUNT(*) FROM aml_transactions
GROUP BY Sender_account, Date HAVING COUNT(*) > 10;
-- Currency Mismatch Analysis
SELECT * FROM aml_transactions WHERE Payment_currency <> Received_currency;
-- What percentage of transactions are suspicious?
SELECT 
    COUNT(*) AS total_transactions,
    SUM(Is_laundering) AS suspicious_transactions,
    ROUND((SUM(Is_laundering) * 100.0 / COUNT(*)), 2) AS suspicious_percentage
FROM aml_transactions;
-- Which locations are high risk?
SELECT 
    Sender_bank_location,
    COUNT(*) AS suspicious_count
FROM aml_transactions
WHERE Is_laundering = 1
GROUP BY Sender_bank_location
ORDER BY suspicious_count DESC;
-- Who are the high-risk customers?
SELECT Sender_account, COUNT(*) AS suspicious_count FROM aml_transactions
WHERE Is_laundering = 1 GROUP BY Sender_account ORDER BY suspicious_count DESC LIMIT 10;