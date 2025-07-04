---Scenario 1-Handle exceptions during fund transfers between accounts---

        CREATE OR REPLACE PROCEDURE SafeTransferFunds (
            p_FromAccountID IN NUMBER,
            p_ToAccountID IN NUMBER,
            p_Amount IN NUMBER
        )
        IS
            v_FromBalance NUMBER;
            v_ToBalance NUMBER;
        BEGIN

            SELECT Balance INTO v_FromBalance FROM Accounts WHERE AccountID = p_FromAccountID FOR UPDATE;


            IF v_FromBalance < p_Amount THEN
                RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds in source account.');
            END IF;

            UPDATE Accounts
            SET Balance = Balance - p_Amount,
                LastModified = SYSDATE
            WHERE AccountID = p_FromAccountID;

            UPDATE Accounts
            SET Balance = Balance + p_Amount,
                LastModified = SYSDATE
            WHERE AccountID = p_ToAccountID;

            COMMIT;

        EXCEPTION
            WHEN OTHERS THEN

                ROLLBACK;

                DBMS_OUTPUT.PUT_LINE('Error during fund transfer: ' || SQLERRM);
        END;



---Scenario 2:-Manage errors when updating employee salaries--

   
    CREATE or REPLACE PROCEDURE UpdateSalary(
        empID in NUMBER,
        percen in NUMBER
    )

    BEGIN

        UPDATE Employees
        SET Salary = Salary + (Salary * percen/100)
        WHERE EmployeeID = empID

    COMMIT

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Employee with ID ' || empID || ' does not exist.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Unexpected error while updating salary: ' || SQLERRM);

    END;


---Scenario 3:-Ensure data integrity when adding a new customer.---

    

        CREATE or REPLACE PROCEDURE AddNewCustomer(
            cusID in NUMBER,
            name in VARCHAR2,
            dob in DATE,
            balance in NUMBER
        )

        IS

        BEGIN

            INSERT INTO Customer (customerID, Name, DOB, Balance, lastModified)
            VALUES (cusID, name, dob, balance)

            COMMIT;

        EXCEPTION

             WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Error: Customer with ID ' || cusID || ' already exists.');
            WHEN OTHERS THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Unexpected error while adding new customer: ' || SQLERRM);
        END;