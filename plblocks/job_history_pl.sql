SET SERVEROUTPUT ON;
DECLARE
  v_job_histories_cursor SYS_REFCURSOR;
  v_total_records NUMBER;
  v_total_pages NUMBER;
  v_rec job_history%ROWTYPE;  -- A record type to hold fetched data
BEGIN
  -- Call the stored procedure
  SP_GET_ALL_JOB_HISTORIES(
    p_page_number => 1,       -- Page number (adjust as needed)
    p_page_size => 10,        -- Page size (adjust as needed)
    p_sort_column => 'start_date', -- Sort column (adjust as needed)
    p_sort_direction => 'ASC',  -- Sort direction (adjust as needed)
    p_job_histories_cursor => v_job_histories_cursor,
    p_total_records => v_total_records,
    p_total_pages => v_total_pages
  );

  -- Display total records and pages
  DBMS_OUTPUT.PUT_LINE('Total Records: ' || v_total_records);
  DBMS_OUTPUT.PUT_LINE('Total Pages: ' || v_total_pages);

  -- Fetch and display the data from the cursor
  LOOP
    FETCH v_job_histories_cursor INTO v_rec;  -- Fetch a row into the record
    EXIT WHEN v_job_histories_cursor%NOTFOUND; -- Exit loop when no more rows

    -- Debugging: Print fetched row details
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_rec.employee_id);
    DBMS_OUTPUT.PUT_LINE('Start Date: ' || v_rec.start_date);
    DBMS_OUTPUT.PUT_LINE('End Date: ' || v_rec.end_date);
    DBMS_OUTPUT.PUT_LINE('Job ID: ' || v_rec.job_id);
    DBMS_OUTPUT.PUT_LINE('Department ID: ' || v_rec.department_id);
    DBMS_OUTPUT.PUT_LINE('--------------------');
  END LOOP;

  -- Close the cursor
  CLOSE v_job_histories_cursor;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/



/*
CREATE OR REPLACE PROCEDURE get_employees_by_department (
    p_department_id IN employees.department_id%TYPE
)
AS
    -- Cursor to hold the employee records
    CURSOR c_employees IS
        SELECT
            employee_id,
            first_name,
            last_name,
            job_id,
            salary
        FROM
            employees
        WHERE
            department_id = p_department_id;

    -- Record type to store each employee's data
    r_employee c_employees%ROWTYPE;

BEGIN
    -- Check if the department exists.  Good practice to handle errors.
    IF NOT check_department_exists(p_department_id) THEN
      DBMS_OUTPUT.PUT_LINE('Error: Department ID ' || p_department_id || ' does not exist.');
      RETURN; -- Exit the procedure if the department doesn't exist.
    END IF;


    DBMS_OUTPUT.PUT_LINE('Employees in Department ID: ' || p_department_id);
    DBMS_OUTPUT.PUT_LINE('------------------------------------');

    -- Open the cursor
    OPEN c_employees;

    -- Loop through the cursor and fetch each employee record
    LOOP
        FETCH c_employees INTO r_employee;
        EXIT WHEN c_employees%NOTFOUND; -- Exit the loop when no more records are found

        -- Process each employee record (in this case, just print the details)
        DBMS_OUTPUT.PUT_LINE(r_employee.employee_id || ': ' || r_employee.first_name || ' ' || r_employee.last_name || ', Job: ' || r_employee.job_id || ', Salary: ' || r_employee.salary);

    END LOOP;

    -- Close the cursor
    CLOSE c_employees;

    DBMS_OUTPUT.PUT_LINE('------------------------------------');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employees found for department ID: ' || p_department_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);  -- Handle other potential errors
END;
/


-- Helper function to check if a department exists.  This is a good practice!
CREATE OR REPLACE FUNCTION check_department_exists (
    p_department_id IN departments.department_id%TYPE
) RETURN BOOLEAN
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM departments WHERE department_id = p_department_id;
    RETURN (v_count > 0);
END;
/

set serveroutput on;
call get_employees_by_department(80);

*/

-- Example usage:
-- SET SERVEROUTPUT ON;  -- Important: Enable output to see the results
-- CALL get_employees_by_department(80);  -- Replace 80 with the desired department ID
-- CALL get_employees_by_department(10); -- Example with a different department ID
-- CALL get_employees_by_department(999); -- Example with a non-existent department ID
