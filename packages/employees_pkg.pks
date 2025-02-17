CREATE OR REPLACE PACKAGE employees_pkg AS

    PROCEDURE SP_GET_EMPLOYEES_COUNT (
    p_total_count OUT NUMBER
  );
  
  PROCEDURE SP_GET_ALL_EMPLOYEES_PAGED (
    p_employees_cursor OUT SYS_REFCURSOR,
    p_offset IN NUMBER,
    p_limit IN NUMBER
) ;
  
  PROCEDURE SP_GET_ALL_EMPLOYEES_PAGED_BEFORE_12C (
    p_start_row IN NUMBER,
    p_page_size IN NUMBER,
    p_result_set OUT SYS_REFCURSOR
  );
  


PROCEDURE SP_GET_ALL_EMPLOYEES (
    p_employees_cursor OUT SYS_REFCURSOR
  );

  PROCEDURE SP_GET_ALL_EMPLOYEES_WITH_SIZE (
    p_size IN NUMBER,
    p_employees_cursor OUT SYS_REFCURSOR
  );

  PROCEDURE SP_GET_EMPLOYEE_BY_ID (
    p_emp_id IN employees.employee_id%TYPE,
    p_employee_cursor OUT SYS_REFCURSOR
  );
  
  PROCEDURE SP_CREATE_EMPLOYEE (
    p_employee_id OUT employees.employee_id%TYPE,
    p_first_name IN employees.first_name%TYPE,
    p_last_name  IN employees.last_name%TYPE,
    p_email      IN employees.email%TYPE DEFAULT NULL, 
    p_phone_number IN employees.phone_number%TYPE DEFAULT NULL, 
    p_hire_date IN employees.hire_date%TYPE DEFAULT SYSDATE,
    p_job_id     IN employees.job_id%TYPE,
    p_salary     IN employees.salary%TYPE,
    p_commission_pct IN employees.commission_pct%TYPE DEFAULT NULL,  
    p_manager_id     IN employees.manager_id%TYPE DEFAULT NULL, 
    p_department_id IN employees.department_id%TYPE
    );
  
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
    );
  
  PROCEDURE SP_DELETE_EMPLOYEE (
    p_emp_id IN employees.employee_id%TYPE
    );
    
    PROCEDURE SP_GET_ALL_EMPLOYEES_BY_DEPARTMENT2(
        p_employees_cursor OUT SYS_REFCURSOR,
        p_department_id IN departments.department_id%TYPE       
    );
    
    PROCEDURE SP_GET_ALL_EMPLOYEES_BY_DEPARTMENT(
        p_employees_cursor OUT SYS_REFCURSOR,
        p_department_id IN departments.department_id%TYPE,
        p_offset IN NUMBER,
        p_limit IN NUMBER
    );
    
    PROCEDURE SP_GET_ALL_EMPLOYEES_BY_JOB(
        p_employees_cursor OUT SYS_REFCURSOR,
        p_job_id IN jobs.job_id%TYPE
    );

    
    PROCEDURE SP_GET_ALL_EMPLOYEES_BY_JOB_PAGED(
        p_employees_cursor OUT SYS_REFCURSOR,
        p_job_id IN jobs.job_id%TYPE,
        p_offset IN NUMBER,
        p_limit IN NUMBER
    );
    
    PROCEDURE GET_N_TOP_EMPLOYEES_BY_SALARY(
        p_number_employees IN NUMBER,
        p_employees_cursor OUT SYS_REFCURSOR
        
    );
    
    
    PROCEDURE GET_EMPLOYEES_BY_SALARY_RANGE 
    (
        p_employees_cursor OUT SYS_REFCURSOR,
        p_min_salary IN NUMBER,
        p_max_salary IN NUMBER
    );
    
  

END employees_pkg;
/