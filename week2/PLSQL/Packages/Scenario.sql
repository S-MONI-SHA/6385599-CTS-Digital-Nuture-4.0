--------------------------------------------------------
-- 🔸 Scenario 1: Customer Management Package
--------------------------------------------------------

CREATE OR REPLACE PACKAGE CustomerManagement AS
    -- Procedure to add a new customer
    PROCEDURE AddCustomer(
        p_CustomerID NUMBER,
        p_Name VARCHAR2,
        p_DOB DATE,
        p_Balance NUMBER
    );

    -- Procedure to update customer details
    PROCEDURE UpdateCustomer(
        p_CustomerID NUMBER,
        p_Name VARCHAR2,
        p_DOB DATE,
        p_Balance NUMBER
    );

    -- Function to get customer balance
    FUNCTION GetCustomerBalance(
        p_CustomerID NUMBER
    ) RETURN NUMBER;
END CustomerManagement;
/

--------------------------------------------------------
-- 🔸 Scenario 2: Employee Management Package
--------------------------------------------------------

CREATE OR REPLACE PACKAGE EmployeeManagement AS
    -- Procedure to hire a new employee
    PROCEDURE HireEmployee(
        p_EmployeeID NUMBER,
        p_Name VARCHAR2,
        p_Position VARCHAR2,
        p_Salary NUMBER,
        p_Department VARCHAR2
    );

    -- Procedure to update employee details
    PROCEDURE UpdateEmployee(
        p_EmployeeID NUMBER,
        p_Name VARCHAR2,
        p_Position VARCHAR2,
        p_Salary NUMBER,
        p_Department VARCHAR2
    );

    -- Function to calculate annual salary
    FUNCTION CalculateAnnualSalary(
        p_EmployeeID NUMBER
    ) RETURN NUMBER;
END EmployeeManagement;
/

--------------------------------------------------------
-- 🔸 Scenario 3: Account Operations Package
--------------------------------------------------------

CREATE OR REPLACE PACKAGE AccountOperations AS
    -- Procedure to open a new account
    PROCEDURE OpenAccount(
        p_AccountID NUMBER,
        p_CustomerID NUMBER,
        p_AccountType VARCHAR2,
        p_Balance NUMBER
    );

    -- Procedure to close an account
    PROCEDURE CloseAccount(
        p_AccountID NUMBER
    );

    -- Function to get total balance of a customer
    FUNCTION GetTotalCustomerBalance(
        p_CustomerID NUMBER
    ) RETURN NUMBER;
END AccountOperations;
/
