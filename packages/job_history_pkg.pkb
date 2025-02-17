-- IMPLEMENTATION JOB HISTORY BODY PACKAGE

CREATE OR REPLACE PACKAGE BODY job_history_pkg 
AS

-- get all job histories
PROCEDURE SP_GET_ALL_JOB_HISTORIES(
    p_job_histories_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_job_histories_cursor FOR
        SELECT 
            employee_id,
            start_date,
            end_date,
            job_id,
            department_id
        FROM job_history;
        
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-2001, 'Error in SP_GET_ALL_JOB_HISTORIES: ' || SQLERRM);
END  SP_GET_ALL_JOB_HISTORIES;

-- get all job histories paged
PROCEDURE SP_GET_ALL_JOB_HISTORIES_PAGED(
    p_job_histories_cursor OUT SYS_REFCURSOR,
    p_offset IN NUMBER,
    p_limit IN NUMBER
)
AS 
BEGIN
    OPEN p_job_histories_cursor FOR
        SELECT employee_id,
            start_date,
            end_date,
            job_id,
            department_id
        FROM job_history
        OFFSET p_offset ROWS FETCH NEXT p_limit ROWS ONLY;
END SP_GET_ALL_JOB_HISTORIES_PAGED;

-- get job history by employee id
PROCEDURE SP_GET_JOB_HISTORY_BY_EMPLOYEE_ID (
    p_employee_id IN job_history.employee_id%TYPE,
    p_job_history_cursor OUT SYS_REFCURSOR
  )
AS
BEGIN
    OPEN p_job_history_cursor FOR 
        SELECT 
            employee_id,
               start_date,
               end_date,
               job_id,
               department_id
        FROM job_history
        WHERE employee_id = p_employee_id;
        
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SP_GET_JOB_HISTORY_BY_EMPLOYEE_ID: ' || SQLERRM);
        RAISE;  


END SP_GET_JOB_HISTORY_BY_EMPLOYEE_ID;


  -- Gets all job histories paged.
  PROCEDURE SP_GET_ALL_JOB_HISTORIES_PAGED (
    p_page_number IN NUMBER DEFAULT 1,
    p_page_size IN NUMBER DEFAULT 10,
    p_sort_column IN VARCHAR2 DEFAULT 'employee_id',
    p_sort_direction IN VARCHAR2 DEFAULT 'ASC',
    p_job_histories_cursor OUT SYS_REFCURSOR,
    p_total_records OUT NUMBER,
    p_total_pages OUT NUMBER
  )
IS
    -- fot starting row of current page
    v_offset NUMBER; 
    -- prevent sql injection
    v_valid_columns VARCHAR2(1000) := 'employee_id,start_date,end_date,job_id,department_id';    
    v_dynamic_sql VARCHAR2(4000);
BEGIN    
    -- Handle negative input for p_size
    IF NOT UTIL_PKG.validate_parameter_size(p_page_size) THEN
         RETURN;
    END IF;
    
    -- Get total records
    p_total_records := UTIL_PKG.get_total_records('job_history');
    
    -- Calculate offset(to determine the starting row for the current page) and total pages
    v_offset :=  (p_page_number - 1) * p_page_size;
    p_total_pages := CEIL(p_total_records / p_page_size);
    
    IF INSTR(v_valid_columns, p_sort_column) = 0 THEN
         RAISE_APPLICATION_ERROR(-20004, 'Invalid sort column');
    END IF;
    
    v_dynamic_sql := 
    'SELECT employee_id, start_date, end_date, job_id, department_id 
     FROM (
        SELECT employee_id, start_date, end_date, job_id, department_id,
               ROW_NUMBER() OVER (ORDER BY ' || p_sort_column || ' ' || p_sort_direction || ') AS rnum
        FROM job_history
     ) 
     WHERE rnum BETWEEN :start_row + 1 AND :end_row';

    
    OPEN p_job_histories_cursor FOR v_dynamic_sql 
    USING v_offset, (v_offset + p_page_size);
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 
        'Error getting job histories: ' || SUBSTR(SQLERRM, 1, 200));
END SP_GET_ALL_JOB_HISTORIES_PAGED;



    PROCEDURE SP_GET_JOB_HISTORY_BY_ID_AND_DATE (
        p_employee_id IN job_history.employee_id%TYPE,
        p_start_date IN job_history.start_date%TYPE,
        p_job_history_cursor OUT SYS_REFCURSOR
    ) 
    IS        
    BEGIN
        IF p_employee_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20007, 'Employee ID cannot be null');
        END IF;
        
        IF p_start_date IS NULL THEN
            RAISE_APPLICATION_ERROR(-20008, 'Start date cannot be null');
        END IF;
        
        OPEN p_job_history_cursor FOR
            SELECT jh.*,
                e.first_name,
                e.last_name,
                j.job_title,
                d.department_name
            FROM job_history jh
            JOIN employees e ON jh.employee_id = e.employee_id
            JOIN jobs j ON jh.job_id = j.job_id
            JOIN departments d ON jh.department_id = d.department_id
            WHERE jh.employee_id = p_employee_id
            AND jh.start_date = p_start_date;
            
        
        IF p_job_history_cursor%NOTFOUND THEN
            CLOSE p_job_history_cursor; 
            RAISE_APPLICATION_ERROR(-20009,
                'No job history found for employee_id: ' || p_employee_id ||
                ' and start_date: ' || TO_CHAR(p_start_date, 'YYYY-MM-DD'));
        END IF;
        
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20010,
                    'Error retrieving job history: ' || SUBSTR(SQLERRM, 1, 200));
        END SP_GET_JOB_HISTORY_BY_ID_AND_DATE;
    
    

END job_history_pkg;
/
    
    
