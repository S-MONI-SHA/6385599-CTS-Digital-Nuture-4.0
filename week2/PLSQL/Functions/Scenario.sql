SET SERVEROUTPUT ON;

--------------------------------------------------------
-- 🔸 Scenario 1: Calculate the age of customers
--------------------------------------------------------

CREATE OR REPLACE FUNCTION CalculateAge(
    dob IN DATE
) RETURN NUMBER
IS
    age NUMBER;
BEGIN
    age := TRUNC(MONTHS_BETWEEN(SYSDATE, dob) / 12);
    RETURN age;
END;
/

--------------------------------------------------------
-- 🔸 Scenario 2: Calculate Monthly Installment for Loan
--------------------------------------------------------

CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment(
    loanAmount IN NUMBER,
    annualInterest IN NUMBER,
    loanDuration IN NUMBER
) RETURN NUMBER
IS
    monthlyInstallment NUMBER;
BEGIN
    monthlyInstallment := (loanAmount + (loanAmount * annualInterest / 100) * loanDuration) 
                          / (12 * loanDuration);
    RETURN monthlyInstallment;
END;
/

--------------------------------------------------------
-- 🔸 Scenario 3: Check Sufficient Balance in Account
--------------------------------------------------------

CREATE OR REPLACE FUNCTION HasSufficientBalance(
    p_AccountID IN NUMBER,
    p_Amount IN NUMBER
) RETURN BOOLEAN
IS
    v_Balance NUMBER;
BEGIN
    SELECT Balance INTO v_Balance
    FROM Accounts
    WHERE AccountID = p_AccountID;

    IF v_Balance >= p_Amount THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    WHEN OTHERS THEN
        RETURN FALSE;
END;
/
