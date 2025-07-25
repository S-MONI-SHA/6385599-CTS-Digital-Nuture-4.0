SET SERVEROUTPUT ON;

--------------------------------------------------------
-- 🔸 Trigger 1: Update Customer Last Modified Date
--------------------------------------------------------

CREATE OR REPLACE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    :NEW.LastModified := SYSDATE;
END;
/

--------------------------------------------------------
-- 🔸 Trigger 2: Maintain Audit Log for Transactions
--------------------------------------------------------

CREATE OR REPLACE TRIGGER LogTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (
        TransactionID, AccountID, TransactionDate, 
        Amount, TransactionType, LoggedAt
    )
    VALUES (
        :NEW.TransactionID, :NEW.AccountID, :NEW.TransactionDate, 
        :NEW.Amount, :NEW.TransactionType, SYSDATE
    );
END;
/

--------------------------------------------------------
-- 🔸 Trigger 3: Enforce Transaction Rules (Deposits/Withdrawals)
--------------------------------------------------------

CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
    v_Balance NUMBER;
BEGIN
    -- Get current balance
    SELECT Balance INTO v_Balance
    FROM Accounts
    WHERE AccountID = :NEW.AccountID;

    -- Withdrawal cannot exceed balance
    IF :NEW.TransactionType = 'Withdrawal' AND :NEW.Amount > v_Balance THEN
        RAISE_APPLICATION_ERROR(-20001, '❌ Error: Withdrawal exceeds available balance.');
    END IF;

    -- Deposit must be positive
    IF :NEW.TransactionType = 'Deposit' AND :NEW.Amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, '❌ Error: Deposit amount must be positive.');
    END IF;

    -- Withdrawal must be positive
    IF :NEW.TransactionType = 'Withdrawal' AND :NEW.Amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '❌ Error: Withdrawal amount must be positive.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, '❌ Error: Account does not exist.');
END;
/
