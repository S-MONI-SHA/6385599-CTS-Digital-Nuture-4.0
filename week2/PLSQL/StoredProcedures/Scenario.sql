SET SERVEROUTPUT ON;

--------------------------------------------------------
-- 🔸 Create Tables
--------------------------------------------------------

-- Accounts Table
CREATE TABLE Accounts (
    AccountID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    Balance NUMBER,
    AccountType VARCHAR2(20) -- Example: 'Savings', 'Current'
);

-- Employees Table
CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    Department VARCHAR2(50),
    Salary NUMBER
);

--------------------------------------------------------
-- 🔸 Insert Sample Data
--------------------------------------------------------

-- Accounts
INSERT INTO Accounts VALUES (1, 101, 5000, 'Savings');
INSERT INTO Accounts VALUES (2, 102, 3000, 'Current');
INSERT INTO Accounts VALUES (3, 103, 10000, 'Savings');
INSERT INTO Accounts VALUES (4, 104, 7000, 'Savings');

-- Employees
INSERT INTO Employees VALUES (201, 'John Smith', 'Finance', 50000);
INSERT INTO Employees VALUES (202, 'Alice Brown', 'HR', 45000);
INSERT INTO Employees VALUES (203, 'Robert White', 'Finance', 55000);
INSERT INTO Employees VALUES (204, 'Emily Davis', 'IT', 60000);

COMMIT;

--------------------------------------------------------
-- 🔸 Scenario 1: Process Monthly Interest for Savings Accounts
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
BEGIN
    UPDATE Accounts
    SET Balance = Balance + (Balance * 0.01)
    WHERE AccountType = 'Savings';

    DBMS_OUTPUT.PUT_LINE('✅ Monthly interest applied to savings accounts.');

    COMMIT;
END;
/

--------------------------------------------------------
-- 🔸 Scenario 2: Update Employee Bonus Based on Department
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    p_Depart IN VARCHAR2,
    p_BonusPerc IN NUMBER
) IS
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * (p_BonusPerc / 100))
    WHERE Department = p_Depart;

    DBMS_OUTPUT.PUT_LINE('✅ Bonus of ' || p_BonusPerc || '% applied to department ' || p_Depart);

    COMMIT;
END;
/

--------------------------------------------------------
-- 🔸 Scenario 3: Transfer Funds Between Accounts
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE TransferFunds (
    sourceAccountId IN NUMBER,
    targetAccountId IN NUMBER,
    amount IN NUMBER
) IS
    sourceBalance NUMBER;
BEGIN
    -- Fetch the source balance
    SELECT Balance INTO sourceBalance
    FROM Accounts
    WHERE AccountID = sourceAccountId
    FOR UPDATE;

    -- Check for sufficient funds
    IF sourceBalance < amount THEN
        RAISE_APPLICATION_ERROR(-20001, '❌ Insufficient funds in the source account.');
    END IF;

    -- Debit from source account
    UPDATE Accounts
    SET Balance = Balance - amount
    WHERE AccountID = sourceAccountId;

    -- Credit to target account
    UPDATE Accounts
    SET Balance = Balance + amount
    WHERE AccountID = targetAccountId;

    DBMS_OUTPUT.PUT_LINE('✅ Transfer of ' || amount || ' from Account ' || sourceAccountId || 
                          ' to Account ' || targetAccountId || ' completed.');

    COMMIT;
END;
/

--------------------------------------------------------
-- 🔸 Example Execution of Procedures (Optional)
--------------------------------------------------------

-- Apply monthly interest
EXEC ProcessMonthlyInterest;

-- Update bonus for Finance department by 10%
EXEC UpdateEmployeeBonus('Finance', 10);

-- Transfer 500 from Account 1 to Account 2
EXEC TransferFunds(1, 2, 500);

--------------------------------------------------------
-- 🔸 Check Updates (Optional Queries)
--------------------------------------------------------

-- Check Accounts table
SELECT * FROM Accounts;

-- Check Employees table
SELECT * FROM Employees;
