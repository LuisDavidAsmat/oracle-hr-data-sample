-- DEPARTMENTS body package implementation

-- get all n deparments
CREATE OR REPLACE PACKAGE BODY departments_pkg AS

PROCEDURE SP_GET_ALL_DEPARTMENTS (
    p_departments_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_departments_cursor FOR
        SELECT department_id, department_name, manager_id, location_id
        FROM departments;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SP_GET_ALL_DEPARTMENTS: ' || SQLERRM);
        RAISE;
END SP_GET_ALL_DEPARTMENTS;


PROCEDURE SP_GET_ALL_DEPARTMENTS_PAGED(
    p_department_cursor OUT SYS_REFCURSOR,
    p_offset IN NUMBER,
    p_limit IN NUMBER
)
AS 
BEGIN
    OPEN p_department_cursor FOR
        SELECT department_id,
            department_name,
            manager_id,
            location_id
            
        FROM departments
        ORDER BY department_id
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;
END SP_GET_ALL_DEPARTMENTS_PAGED;


PROCEDURE SP_GET_ALL_DEPARTMENTS_WITH_SIZE (
    p_size IN NUMBER,
    p_departments_cursor OUT SYS_REFCURSOR
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
    
    OPEN p_departments_cursor FOR
        SELECT department_id, department_name, manager_id, location_id
        FROM departments
        WHERE ROWNUM <= v_size;
        
exception
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SP_GET_ALL_DEPARTMENTS: ' || SQLERRM);
        raise;
END SP_GET_ALL_DEPARTMENTS_WITH_SIZE;


-- get department by id
PROCEDURE SP_GET_DEPARTMENT_BY_ID (
    p_department_id IN departments.department_id%TYPE,
    p_department_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_department_cursor FOR
        SELECT department_id, department_name, manager_id, location_id
        FROM departments
        WHERE department_id = p_department_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Department not found: ' || p_department_id);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error in SP_GET_DEPARTMENT_BY_ID: ' || SQLERRM);
END SP_GET_DEPARTMENT_BY_ID;


-- create department
PROCEDURE SP_CREATE_DEPARTMENT (
    p_department_id OUT departments.department_id%TYPE,
    p_department_name IN departments.department_name%TYPE,
    p_manager_id IN departments.manager_id%TYPE DEFAULT NULL, 
    p_location_id IN departments.location_id%TYPE
)
AS 
    v_department_id departments.department_id%TYPE;
BEGIN
    IF p_department_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Department name is required.');
    ELSIF p_location_id IS NULL THEN  
        RAISE_APPLICATION_ERROR(-20002, 'Location ID is required.');
    END IF;
    
    SELECT departments_seq.NEXTVAL INTO v_department_id FROM dual;
    
    INSERT INTO departments (
        department_id ,
        department_name ,
        manager_id ,
        location_id 
    
    )VALUES (
        v_department_id,
        p_department_name ,
        p_manager_id ,
        p_location_id 
    );
    
    p_department_id := v_department_id;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SP_CREATE_EMPLOYEE: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END SP_CREATE_DEPARTMENT;



-- update department
PROCEDURE SP_UPDATE_DEPARTMENT (
    p_department_id IN departments.department_id%TYPE,
    p_department_name IN departments.department_name%TYPE,
    p_manager_id IN departments.manager_id%TYPE DEFAULT NULL, 
    p_location_id IN departments.location_id%TYPE,
    p_rowcount OUT NUMBER
)
AS
    v_count NUMBER;
BEGIN
    IF p_department_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Department ID is required');
    END IF;
    
    SELECT COUNT (*) INTO v_count FROM departments WHERE department_id = p_department_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Department not found');
    END IF;
    
    UPDATE departments
    SET
        department_name = NVL(p_department_name, department_name),
        manager_id = NVL(p_manager_id, manager_id),
        location_id = NVL(p_location_id, location_id)
    WHERE department_id = p_department_id;
    
    p_rowcount := SQL%ROWCOUNT;
    
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error updating department: ' || SQLERRM);
    
        ROLLBACK;
        RAISE;
END SP_UPDATE_DEPARTMENT;



-- delete user
PROCEDURE SP_DELETE_DEPARTMENT (
    p_department_id IN departments.department_id%TYPE,
    p_rowcount OUT NUMBER 
)
AS
    v_count NUMBER;
BEGIN
    IF p_department_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Department ID is required');
    END IF;
    
    SELECT COUNT(*) INTO v_count FROM departments WHERE department_id = p_department_id;
    
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Employee not found');
    END IF;
    
    DELETE FROM departments WHERE department_id = p_department_id;
    
    p_rowcount := SQL%ROWCOUNT;
    
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SP_DELETE_EMPLOYEE: ' || SQLERRM);
        
        ROLLBACK;
        RAISE;
END SP_DELETE_DEPARTMENT;

PROCEDURE GET_AVERAGE_SALARY_BY_DEPARTMENT(
        p_avg_salary_cursor OUT SYS_REFCURSOR,
        p_department_id IN NUMBER
    )
    IS 
        v_dept_counter NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_dept_counter FROM departments WHERE department_id = p_department_id;
        
        IF v_dept_counter = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Department was not found.');
        END IF;
        
        OPEN p_avg_salary_cursor FOR
            SELECT d.department_id, d.department_name, AVG(e.salary) AS average_salary
            FROM employees e
            JOIN departments d ON e.department_id = d.department_id
            WHERE d.department_id = p_department_id
            GROUP BY d.department_id, d.department_name;
    
END GET_AVERAGE_SALARY_BY_DEPARTMENT;

END departments_pkg;
/