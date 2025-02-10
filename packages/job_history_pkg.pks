-- DEPARTMENTS
CREATE OR REPLACE PACKAGE job_history_pkg AS

    -- Gets all job histories.
  PROCEDURE SP_GET_ALL_JOB_HISTORIES (
    p_page_number IN NUMBER DEFAULT 1,
    p_page_size IN NUMBER DEFAULT 10,
    p_sort_column IN VARCHAR2 DEFAULT 'employee_id',
    p_sort_direction IN VARCHAR2 DEFAULT 'ASC',
    p_job_histories_cursor OUT SYS_REFCURSOR,
    p_total_records OUT NUMBER,
    p_total_pages OUT NUMBER
  );
    
    -- Gets a job history by its ID.
  PROCEDURE SP_GET_JOB_HISTORY_BY_ID (
    p_employee_id IN job_history.employee_id%TYPE,
    p_start_date IN job_history.start_date%TYPE,
    p_job_history_cursor OUT SYS_REFCURSOR
  );
  
  -- Creates a new job history.
  /* SP_CREATE_JOB_HISTORY (
    p_employee_id IN job_history.employee_id%TYPE,
    p_start_date IN job_history.start_date%TYPE,
    p_end_date IN job_history.end_date%TYPE,
    p_job_id IN job_history.job_id%TYPE,
    p_department_id IN job_history.department_id%TYPE
    );
    
  -- Updates existing job history.
  PROCEDURE SP_UPDATE_JOB_HISTORY (
    p_employee_id IN job_history.employee_id%TYPE,
    p_start_date IN job_history.start_date%TYPE,
    p_end_date IN job_history.end_date%TYPE,
    p_job_id IN job_history.job_id%TYPE,
    p_department_id IN job_history.department_id%TYPE,
    p_rowcount OUT NUMBER
    );
  
  -- Deletes existing job history.
  PROCEDURE SP_DELETE_JOB_HISTORY (
    p_employee_id IN job_history.employee_id%TYPE,
    p_start_date IN job_history.start_date%TYPE,
    p_rowcount OUT NUMBER 
    );
*/
END job_history_pkg;
/