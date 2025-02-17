-- DEPARTMENTS

SET SERVEROUTPUT ON;

DECLARE
    v_cursor SYS_REFCURSOR;
    TYPE department_rec_type IS RECORD (
        department_id departments.department_id%TYPE,
        department_name departments.department_name%TYPE,
        manager_id departments.manager_id%TYPE,
        location_id departments.location_id%TYPE
        );
     v_department_rec department_rec_type;
     
     v_size NUMBER := 10;
BEGIN
    departments_pkg.SP_GET_ALL_DEPARTMENTS(v_size, v_cursor); -- Call the procedure

    LOOP
        FETCH v_cursor INTO v_department_rec;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
        v_department_rec.department_id  || ': ' || 
        v_department_rec.department_name || ' Manager: ' || 
        v_department_rec.manager_id || ', Location: ' ||
        v_department_rec.location_id);

    END LOOP;

    CLOSE v_cursor;
END;
/

SET SERVEROUTPUT ON;
DECLARE 
    v_department_cursor SYS_REFCURSOR;
    v_department_id     departments.department_id%TYPE := 30;
    v_department_name     departments.department_name%TYPE;
    v_manager_id      departments.manager_id%TYPE;
    v_location_id   departments.location_id%TYPE;
BEGIN
    departments_pkg.SP_GET_DEPARTMENT_BY_ID(v_department_id, v_department_cursor); 
    LOOP
        FETCH v_department_cursor INTO
            v_department_id,
            v_department_name,
            v_manager_id,
            v_location_id;
            
        EXIT WHEN v_department_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(
        v_department_id  || ': ' || 
        v_department_name || ' Manager: ' || 
        v_manager_id || ', Location: ' ||
        v_location_id);
    END LOOP;
    
    CLOSE v_department_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- create employee pl/sql block
SET SERVEROUTPUT ON;
DECLARE
    
    v_department_id     departments.department_id%TYPE;
--    v_department_name   departments.department_name%TYPE := 'Logistics';
    v_department_name   departments.department_name%TYPE := 'Credits Collection';
    v_manager_id    departments.manager_id%TYPE := 103;
    v_location_id   departments.location_id%TYPE := 1700;
    

BEGIN
    departments_pkg.SP_CREATE_DEPARTMENT(v_department_id, v_department_name, v_manager_id, v_location_id);

    DBMS_OUTPUT.PUT_LINE('New department created with ID: ' || v_department_id);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error creating department: ' || SQLERRM);
        ROLLBACK;

END;
/


-- update employee pl/sql block
SET SERVEROUTPUT ON;
DECLARE 
    v_department_id     departments.department_id%TYPE := 290;
    v_department_name   departments.department_name%TYPE := 'Credits and Collection';
    v_manager_id    departments.manager_id%TYPE := 103;
    v_location_id   departments.location_id%TYPE := 1700;
    v_rowcount          NUMBER;
    
BEGIN
    --departments_pkg.SP_UPDATE_DEPARTMENT(v_department_id, v_department_name, v_manager_id, v_location_id);
    departments_pkg.SP_UPDATE_DEPARTMENT(
        p_department_id => v_department_id,
        p_department_name => v_department_name,
        p_manager_id => v_manager_id,
        p_location_id => v_location_id,
        p_rowcount => v_rowcount 
    );
    
    -- To check if rows were actually updated
    IF v_rowcount > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('Department updated.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No department found with ID: ' || v_department_id);
        
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error updating department: ' || SQLERRM);
    ROLLBACK;
END;
/

-- delete department 
SET SERVEROUTPUT ON;

DECLARE
    v_department_id departments.department_id%TYPE := 290;
    v_rowcount      NUMBER;
BEGIN
    departments_pkg.sp_delete_department(
        p_department_id => v_department_id,
        p_rowcount => v_rowcount
    );
    
    IF v_rowcount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Department ' || v_department_id || ' deleted successfully.');
        COMMIT;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('No department found with ID: ' || v_department_id);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Department deleting department: ' || sqlerrm);
        ROLLBACK;
END;
/

SET SERVEROUTPUT ON
DECLARE
  rc SYS_REFCURSOR;
  v_department_id departments.department_id%TYPE := 10; -- Replace with the desired department ID
  v_department_name departments.department_name%TYPE;
  v_average_salary NUMBER;
BEGIN
  -- Call the stored procedure
  departments_pkg.GET_AVERAGE_SALARY_BY_DEPARTMENT(rc, v_department_id);

  -- Fetch and process the results from the cursor
  LOOP
    FETCH rc INTO v_department_id, v_department_name, v_average_salary;
    EXIT WHEN rc%NOTFOUND;

    -- Process the data (e.g., print it)
    DBMS_OUTPUT.PUT_LINE('Department ID: ' || v_department_id);
    DBMS_OUTPUT.PUT_LINE('Department Name: ' || v_department_name);
    DBMS_OUTPUT.PUT_LINE('Average Salary: ' || v_average_salary);
    DBMS_OUTPUT.PUT_LINE('--------------------');
  END LOOP;

  -- Close the cursor
  CLOSE rc;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM); -- Handle exceptions
END;
/
