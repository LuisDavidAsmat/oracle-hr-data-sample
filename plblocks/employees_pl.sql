SET SERVEROUTPUT ON;

DECLARE
    v_cursor SYS_REFCURSOR;
    TYPE employee_rec_type IS RECORD (
        employee_id employees.employee_id%TYPE,
        first_name employees.first_name%TYPE,
        last_name employees.last_name%TYPE
        );
     v_employee_rec employee_rec_type;
BEGIN
    employees_pkg.SP_GET_ALL_EMPLOYEES(10, v_cursor); -- Call the procedure

    LOOP
        FETCH v_cursor INTO v_employee_rec;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_employee_rec.employee_id || ': ' || v_employee_rec.first_name || ' ' || v_employee_rec.last_name);

    END LOOP;

    CLOSE v_cursor;
END;
/

SET SERVEROUTPUT ON;
DECLARE 
    v_employee_cursor SYS_REFCURSOR;
    v_employee_id employees.employee_id%TYPE := 102;
    v_id             employees.employee_id%TYPE;
    v_first_name     employees.first_name%TYPE;
    v_last_name      employees.last_name%TYPE;
BEGIN
    employees_pkg.SP_GET_EMPLOYEE_BY_ID(v_employee_id, v_employee_cursor); 
    LOOP
        FETCH v_employee_cursor INTO
            v_id,
            v_first_name,
            v_last_name;
        EXIT WHEN v_employee_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('User ID: ' || v_id || ' | Name: ' || v_first_name || ' Surname:' || v_last_name);
    END LOOP;
    
    CLOSE v_employee_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- create employee pl/sql block
SET SERVEROUTPUT ON;
DECLARE
    
    v_new_emp_id employees.employee_id%TYPE; 
    v_first_name employees.first_name%TYPE := 'Jane';
    v_last_name employees.last_name%TYPE := 'Doe';
    v_email employees.email%TYPE := 'JANEDOE';
    v_phone_number employees.phone_number%TYPE := '1.515.555.0171';
    v_hire_date employees.hire_date%TYPE := DATE '2012-06-07';
    v_job_id employees.job_id%TYPE := 'IT_PROG';
    v_salary employees.salary%TYPE := 6000;
    v_department_id employees.department_id%TYPE := 90;
    v_manager_id employees.manager_id%TYPE := 103;
    v_commission_pct employees.commission_pct%TYPE := 0.15;
    

BEGIN
    employees_pkg.SP_CREATE_EMPLOYEE(v_new_emp_id, v_first_name, v_last_name, v_email, v_phone_number, v_hire_date, v_job_id, v_salary, v_commission_pct, v_manager_id, v_department_id);

    DBMS_OUTPUT.PUT_LINE('New employee created with ID: ' || v_new_emp_id);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error calling SP_CREATE_EMPLOYEE: ' || SQLERRM);
        ROLLBACK;

END;
/


-- update employee pl/sql block
SET SERVEROUTPUT ON;
DECLARE
    
    v_emp_id employees.employee_id%TYPE := 213; 
    v_first_name employees.first_name%TYPE := 'Janey';
    v_last_name employees.last_name%TYPE := 'Doei';
    v_salary employees.salary%TYPE := 7000;
    

BEGIN
    employees_pkg.SP_UPDATE_EMPLOYEE(v_emp_id, v_first_name, v_last_name, v_salary);

    DBMS_OUTPUT.PUT_LINE('Employee updated.');
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error updating user: ' || SQLERRM);
    ROLLBACK;
END;
/

-- delete employee 
SET SERVEROUTPUT ON;

DECLARE
    v_emp_id employees.employee_id%TYPE := 213;
BEGIN
    employees_pkg.sp_delete_employee(v_emp_id);
    dbms_output.put_line('Employee deleted.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error deleting user: ' || sqlerrm);
        ROLLBACK;
END;
/

