SET SERVEROUTPUT ON;

--------------------------------------------------------
-- 🔸 Scenario 1: Generate Monthly Statements for Customers
--------------------------------------------------------

DECLARE
    CURSOR cur_MonthlyTransactions IS
        SELECT t.TransactionID, t.AccountID, t.TransactionDate, t.Amount, 
               t.TransactionType, c.CustomerID, c.Name
        FROM Transactions t
        JOIN Accounts a ON t.AccountID = a.AccountID
        JOIN Customers c ON a.CustomerID = c.CustomerID
        WHERE TO_CHAR(t.TransactionDate, 'YYYYMM') = TO_CHAR(SYSDATE, 'YYYYMM')
        ORDER BY c.CustomerID, t.TransactionDate;

    v_Transaction cur_MonthlyTransactions%ROWTYPE;
    v_CurrentCustomerID NUMBER := NULL;
BEGIN
    OPEN cur_MonthlyTransactions;
    LOOP
        FETCH cur_MonthlyTransactions INTO v_Transaction;
        EXIT WHEN cur_MonthlyTransactions%NOTFOUND;

        IF v_CurrentCustomerID != v_Transaction.CustomerID THEN
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Monthly Statement for Customer: ' || v_Transaction.CustomerID || ' - ' || v_Transaction.Name);
            DBMS_OUTPUT.PUT_LINE('Date       | Transaction   | Amount');
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
            v_CurrentCustomerID := v_Transaction.CustomerID;
        END IF;

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_Transaction.TransactionDate, 'YYYY-MM-DD') || ' | ' ||
                             RPAD(v_Transaction.TransactionType, 13) || ' | ' ||
                             v_Transaction.Amount);
    END LOOP;

    CLOSE cur_MonthlyTransactions;
END;
/

--------------------------------------------------------
-- 🔸 Scenario 2: Apply Annual Fee to All Accounts
--------------------------------------------------------

DECLARE
    CURSOR cur_Accounts IS
        SELECT AccountID, Balance FROM Accounts FOR UPDATE;

    v_Account cur_Accounts%ROWTYPE;
    v_AnnualFee CONSTANT NUMBER := 50;
BEGIN
    OPEN cur_Accounts;
    LOOP
        FETCH cur_Accounts INTO v_Account;
        EXIT WHEN cur_Accounts%NOTFOUND;

        UPDATE Accounts
        SET Balance = Balance - v_AnnualFee,
            LastModified = SYSDATE
        WHERE AccountID = v_Account.AccountID;

        DBMS_OUTPUT.PUT_LINE('✅ Annual fee applied to Account ID: ' || v_Account.AccountID);
    END LOOP;

    CLOSE cur_Accounts;
    COMMIT;
END;
/

--------------------------------------------------------
-- 🔸 Scenario 3: Update Loan Interest Rates Based on Policy
--------------------------------------------------------

DECLARE
    CURSOR cur_Loans IS
        SELECT LoanID, InterestRate FROM Loans FOR UPDATE;

    v_Loan cur_Loans%ROWTYPE;
    v_NewInterestRate NUMBER;
BEGIN
    OPEN cur_Loans;
    LOOP
        FETCH cur_Loans INTO v_Loan;
        EXIT WHEN cur_Loans%NOTFOUND;

        v_NewInterestRate := v_Loan.InterestRate + 0.5;

        UPDATE Loans
        SET InterestRate = v_NewInterestRate
        WHERE LoanID = v_Loan.LoanID;

        DBMS_OUTPUT.PUT_LINE('✅ Loan ID: ' || v_Loan.LoanID || ' new interest rate: ' || v_NewInterestRate || '%');
    END LOOP;

    CLOSE cur_Loans;
    COMMIT;
END;
/
