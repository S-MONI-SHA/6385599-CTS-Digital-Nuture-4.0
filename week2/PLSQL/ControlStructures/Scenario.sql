SET SERVEROUTPUT ON;

--------------------------------------------------------
-- Scenario 1: Apply Interest Discount for Customers Above 60
--------------------------------------------------------

BEGIN
    FOR loan_rec IN (
        SELECT l.LoanID
        FROM Customers c
        JOIN Loans l ON l.CustomerID = c.CustomerID
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, c.DOB) / 12) > 60
    ) LOOP
        UPDATE Loans
        SET InterestRate = InterestRate * 0.99 -- Apply 1% discount
        WHERE LoanID = loan_rec.LoanID;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('✅ Interest rate discount applied to customers above 60.');

    COMMIT;
END;
/

--------------------------------------------------------
-- Scenario 2: Promote Customers to VIP Based on Balance
--------------------------------------------------------

BEGIN
    FOR cust_rec IN (
        SELECT CustomerID
        FROM Customers
        WHERE Balance > 10000
    ) LOOP
        UPDATE Customers
        SET IsVIP = 'Y'
        WHERE CustomerID = cust_rec.CustomerID;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('✅ VIP status updated for customers with balance over 10,000.');

    COMMIT;
END;
/

--------------------------------------------------------
-- Scenario 3: Send Loan Due Reminders (Due within 30 Days)
--------------------------------------------------------

DECLARE
    CURSOR loan_cursor IS
        SELECT c.Name AS customer_name, l.LoanID AS loan_id, l.EndDate AS due_date
        FROM Loans l
        JOIN Customers c ON c.CustomerID = l.CustomerID
        WHERE l.EndDate BETWEEN SYSDATE AND SYSDATE + 30;
BEGIN
    FOR loan_rec IN loan_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('📢 Reminder: Loan ID ' || loan_rec.loan_id ||
                              ' for customer ' || loan_rec.customer_name ||
                              ' is due on ' || TO_CHAR(loan_rec.due_date, 'DD-MON-YYYY') || '.');
    END LOOP;
END;
/
