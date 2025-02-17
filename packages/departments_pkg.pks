-- DEPARTMENTS
CREATE OR REPLACE PACKAGE departments_pkg AS

  -- Gets all departments.
  PROCEDURE SP_GET_ALL_DEPARTMENTS (
    p_departments_cursor OUT SYS_REFCURSOR
  );
  
  
  PROCEDURE SP_GET_ALL_DEPARTMENTS_PAGED
  (
    p_department_cursor OUT SYS_REFCURSOR,
    p_offset IN NUMBER,
    p_limit IN NUMBER
    );

    -- Gets all n departments.
  PROCEDURE SP_GET_ALL_DEPARTMENTS_WITH_SIZE (
    p_size IN NUMBER,
    p_departments_cursor OUT SYS_REFCURSOR
  );
    
    -- Gets a department by its ID.
  PROCEDURE SP_GET_DEPARTMENT_BY_ID (
    p_department_id IN departments.department_id%TYPE,
    p_department_cursor OUT SYS_REFCURSOR
  );
  
  -- Creates a new department.
  PROCEDURE SP_CREATE_DEPARTMENT (
    p_department_id OUT departments.department_id%TYPE,
    p_department_name IN departments.department_name%TYPE,
    p_manager_id IN departments.manager_id%TYPE DEFAULT NULL, 
    p_location_id IN departments.location_id%TYPE
    );
    
  -- Updates existing department.
  PROCEDURE SP_UPDATE_DEPARTMENT (
    p_department_id IN departments.department_id%TYPE,
    p_department_name IN departments.department_name%TYPE,
    p_manager_id IN departments.manager_id%TYPE DEFAULT NULL, 
    p_location_id IN departments.location_id%TYPE,
    p_rowcount OUT NUMBER
    );
  
  -- Deletes existing department.
  PROCEDURE SP_DELETE_DEPARTMENT (
    p_department_id IN departments.department_id%TYPE,
    p_rowcount OUT NUMBER 
    );
    
    PROCEDURE GET_AVERAGE_SALARY_BY_DEPARTMENT(
        p_avg_salary_cursor OUT SYS_REFCURSOR,
        p_department_id IN NUMBER
    );

END departments_pkg;
/