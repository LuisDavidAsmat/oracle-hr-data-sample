-- get all n employees
CREATE OR REPLACE PACKAGE BODY employees_pkg AS

PROCEDURE SP_GET_ALL_EMPLOYEES (
    p_size IN NUMBER,
    p_employees_cursor OUT SYS_REFCURSOR
)
AS
    v_size NUMBER;
BEGIN
    -- Handle NULL input for p_size:
    v_size := NVL(p_size, 10);
    
    -- Handle negative input for p_size
    IF v_size <= 0 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Size must be greater than zero');
    ELSIF v_size > 1000 THEN
         RAISE_APPLICATION_ERROR(-20002, 'Size cannot exceed 1000.');
    END IF;
    
    OPEN p_employees_cursor FOR
        SELECT employee_id, first_name, last_name
        FROM employees
        WHERE ROWNUM <= v_size;
        
exception
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SP_GET_ALL_EMPLOYEES: ' || SQLERRM);
        raise;
END SP_GET_ALL_EMPLOYEES;


-- get employee by id
PROCEDURE SP_GET_EMPLOYEE_BY_ID (
    p_emp_id     IN employees.employee_id%TYPE,
    p_employee_cursor OUT SYS_REFCURSOR
)
AS
    v_count NUMBER;
BEGIN

    SELECT COUNT(*) INTO v_count FROM employees WHERE employee_id = p_emp_id;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found: ' || p_emp_id);
        OPEN p_employee_cursor FOR
            SELECT employee_id, first_name, last_name
            FROM employees
            WHERE 1=2;  
    ELSE
        OPEN p_employee_cursor FOR
            SELECT employee_id, first_name, last_name
            FROM employees
            WHERE employee_id = p_emp_id;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error in SP_GET_EMPLOYEE_BY_ID: ' || SQLERRM);
END SP_GET_EMPLOYEE_BY_ID;


-- create user
PROCEDURE SP_CREATE_EMPLOYEE (
    p_employee_id OUT employees.employee_id%TYPE,
    p_first_name IN employees.first_name%TYPE,
    p_last_name  IN employees.last_name%TYPE,
    p_email      IN employees.email%TYPE DEFAULT NULL, 
    p_phone_number IN employees.phone_number%TYPE DEFAULT NULL, 
    p_hire_date IN employees.hire_date%TYPE DEFAULT SYSDATE,
    p_job_id     IN employees.job_id%TYPE,
    p_salary     IN employees.salary%TYPE,
    p_commission_pct IN employees.commission_pct%TYPE DEFAULT NULL,  -- Optional
    p_manager_id     IN employees.manager_id%TYPE DEFAULT NULL, 
    p_department_id IN employees.department_id%TYPE
)
AS 
    v_employee_id employees.employee_id%TYPE;
BEGIN
    IF p_first_name IS NULL OR p_last_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'First name and Last Name are required.');
    ELSIF p_job_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Job ID is required.');
    ELSIF p_salary IS NULL OR p_salary <= 0 THEN  -- Salary validation
        RAISE_APPLICATION_ERROR(-20003, 'Salary must be greater than zero.');
    ELSIF p_department_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'Department ID is required.');
    END IF;
    
    SELECT employees_seq.NEXTVAL INTO v_employee_id FROM dual;
    
    INSERT INTO employees (
        employee_id,
        first_name,
        last_name,
        email,
        phone_number,
        hire_date,
        job_id,
        salary,
        department_id,
        manager_id,
        commission_pct
    
    )VALUES (
        v_employee_id,
        p_first_name,
        p_last_name,
        p_email,
        p_phone_number,
        p_hire_date,
        p_job_id,
        p_salary,
        p_department_id,
        p_manager_id,
        p_commission_pct
    );
    
    p_employee_id := v_employee_id;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SP_CREATE_EMPLOYEE: ' || SQLERRM);
        
    ROLLBACK;
    RAISE;
END SP_CREATE_EMPLOYEE;



-- update user
PROCEDURE SP_UPDATE_EMPLOYEE (
    p_employee_id IN employees.employee_id%TYPE,
    p_first_name IN employees.first_name%TYPE DEFAULT NULL,
    p_last_name IN employees.last_name%TYPE DEFAULT NULL,
    p_email IN employees.email%TYPE DEFAULT NULL,
    p_phone_number IN employees.phone_number%TYPE DEFAULT NULL,
    p_hire_date IN employees.hire_date%TYPE DEFAULT NULL,
    p_job_id IN employees.job_id%TYPE DEFAULT NULL,    
    p_salary IN employees.salary%TYPE DEFAULT NULL,    
    p_commission_pct IN employees.commission_pct%TYPE DEFAULT NULL, 
    p_manager_id IN employees.manager_id%TYPE DEFAULT NULL,
    p_department_id IN employees.department_id%TYPE DEFAULT NULL
)
AS
    v_count NUMBER;
BEGIN
    IF p_employee_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee ID is required');
    END IF;
    
    SELECT COUNT (*) INTO v_count FROM employees WHERE employee_id = p_employee_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Employee not found');
    END IF;
    
    UPDATE employees
    SET
        first_name = NVL(p_first_name, first_name),
        last_name = NVL(p_last_name, last_name),
        email = NVL(p_email, email),
        phone_number = NVL(p_phone_number, phone_number),
        hire_date = NVL(p_hire_date, hire_date),
        job_id = NVL(p_job_id, job_id),
        salary = NVL(p_salary, salary),
        commission_pct = NVL(p_commission_pct, commission_pct),
        manager_id = NVL(p_manager_id, manager_id),
        department_id = NVL(p_department_id, department_id)
    WHERE employee_id = p_employee_id;
    
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SP_UPDATE_EMPLOYEE: ' || SQLERRM);
    
    ROLLBACK;
    RAISE;
END SP_UPDATE_EMPLOYEE;



-- delete user
PROCEDURE SP_DELETE_EMPLOYEE (
    p_emp_id IN employees.employee_id%TYPE
)
AS
    v_count NUMBER;
BEGIN
    IF p_emp_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employe ID is required');
    END IF;
    
    SELECT COUNT(*) INTO v_count FROM employees WHERE employee_id = p_emp_id;
    
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Employee not found');
    END IF;
    
    DELETE FROM job_history
    where employee_id = p_emp_id;
    
    DELETE FROM employees
    WHERE employee_id = p_emp_id;
    
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SP_DELETE_EMPLOYEE: ' || SQLERRM);
        
        ROLLBACK;
        RAISE;
END SP_DELETE_EMPLOYEE;

END employees_pkg;
/