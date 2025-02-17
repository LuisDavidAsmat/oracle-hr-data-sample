-- get all job histories paged
SET SERVEROUTPUT ON
DECLARE
  v_job_histories_cursor SYS_REFCURSOR;
  v_job_history_rec job_history%ROWTYPE;  -- Use rowtype record
  v_offset NUMBER := 0;      -- Example offset (replace with your value)
  v_limit NUMBER := 10;     -- Example limit (replace with your value)
BEGIN
  
  job_history_pkg.SP_GET_ALL_JOB_HISTORIES_PAGED(
    p_job_histories_cursor => v_job_histories_cursor,
    p_offset => v_offset,
    p_limit => v_limit
  );

  -- Fetch and display the results
  LOOP
    FETCH v_job_histories_cursor INTO v_job_history_rec;
    EXIT WHEN v_job_histories_cursor%NOTFOUND;

    -- Process each job history record (display in this example)
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_job_history_rec.employee_id ||
                         ', Start Date: ' || v_job_history_rec.start_date ||
                         ', Job ID: ' || v_job_history_rec.job_id);
    -- ... print other job history details as needed
  END LOOP;

  -- Close the cursor (important!)
  CLOSE v_job_histories_cursor;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

SET SERVEROUTPUT ON;
DECLARE
  v_job_histories_cursor SYS_REFCURSOR;
  v_employee_id job_history.employee_id%TYPE;
  v_start_date job_history.start_date%TYPE;
  v_end_date job_history.end_date%TYPE;
  v_job_id job_history.job_id%TYPE;
  v_department_id job_history.department_id%TYPE;

BEGIN
  
  job_history_pkg.SP_GET_ALL_JOB_HISTORIES(
      p_job_histories_cursor => v_job_histories_cursor
  );

  
  LOOP
    FETCH v_job_histories_cursor INTO v_employee_id, v_start_date, v_end_date, v_job_id, v_department_id;
    EXIT WHEN v_job_histories_cursor%NOTFOUND;

    
    DBMS_OUTPUT.PUT_LINE(
        'Employee ID: ' || v_employee_id || 
        ', Start Date: ' || TO_CHAR(v_start_date, 'YYYY-MM-DD') || 
        ', End Date: ' || TO_CHAR(v_end_date, 'YYYY-MM-DD') || 
        ', Job ID: ' || v_job_id || 
        ', Department ID: ' || v_department_id
    );
  END LOOP;

  
  CLOSE v_job_histories_cursor;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    IF v_job_histories_cursor%ISOPEN THEN
      CLOSE v_job_histories_cursor;
    END IF;
END;
/


SET SERVEROUTPUT ON;
DECLARE
    v_job_history_cursor SYS_REFCURSOR;
    v_employee_id job_history.employee_id%TYPE := 200; 
    v_start_date job_history.start_date%TYPE;
    v_end_date job_history.end_date%TYPE;
    v_job_id job_history.job_id%TYPE;
    v_department_id job_history.department_id%TYPE;
BEGIN
    
    job_history_pkg.SP_GET_JOB_HISTORY_BY_EMPLOYEE_ID(v_employee_id, v_job_history_cursor);

    
    LOOP
        FETCH v_job_history_cursor INTO v_employee_id, v_start_date, v_end_date, v_job_id, v_department_id;
        EXIT WHEN v_job_history_cursor%NOTFOUND;

       
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee_id || ', Start Date: ' || v_start_date || ', End Date: ' || v_end_date || ', Job ID: ' || v_job_id || ', Department ID: ' || v_department_id);
    END LOOP;

    
    IF v_job_history_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No job history found for employee ID: ' || v_employee_id);
    END IF;

    
    CLOSE v_job_history_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/








SET SERVEROUTPUT ON;
DECLARE
  v_job_histories_cursor SYS_REFCURSOR;
  v_total_records NUMBER;
  v_total_pages NUMBER;
  v_rec job_history%ROWTYPE;  
BEGIN
  
    job_history_pkg.SP_GET_ALL_JOB_HISTORIES_PAGED(
    p_page_number => 1,
    p_page_size => 10,
    p_sort_column => 'start_date',
    p_sort_direction => 'ASC',
    p_job_histories_cursor => v_job_histories_cursor,
    p_total_records => v_total_records,
    p_total_pages => v_total_pages
  );

  -- Displays total records and pages
  DBMS_OUTPUT.PUT_LINE('Total Records: ' || v_total_records);
  DBMS_OUTPUT.PUT_LINE('Total Pages: ' || v_total_pages);

  -- Fetch and display the data from the cursor
  LOOP
    FETCH v_job_histories_cursor INTO v_rec;  -- Fetch a row into the record
    EXIT WHEN v_job_histories_cursor%NOTFOUND; 

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

SET SERVEROUTPUT ON;
DECLARE
    v_cursor SYS_REFCURSOR;
    v_employee_id job_history.employee_id%TYPE := 102;
    v_start_date job_history.start_date%TYPE := DATE '2011-01-13';
    
    TYPE job_history_rec IS RECORD (
        employee_id job_history.employee_id%TYPE,
        start_date job_history.start_date%TYPE,
        end_date job_history.end_date%TYPE,
        job_id job_history.job_id%TYPE,
        department_id job_history.department_id%TYPE,
        first_name employees.first_name%TYPE,
        last_name employees.last_name%TYPE,
        job_title jobs.job_title%TYPE,
        department_name departments.department_name%TYPE
    );
    
    v_rec job_history_rec;
BEGIN
    job_history_pkg.SP_GET_JOB_HISTORY_BY_ID_AND_DATE(v_employee_id, v_start_date, v_cursor);
    
    -- Fetch and print results
    LOOP
        FETCH v_cursor INTO v_rec;
        EXIT WHEN v_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Employee:   ' || v_rec.first_name || ' ' || v_rec.last_name);
            DBMS_OUTPUT.PUT_LINE('Employee Id:' || v_rec.employee_id);
            DBMS_OUTPUT.PUT_LINE('Job:        ' || v_rec.job_title);
            DBMS_OUTPUT.PUT_LINE('Job Id:     ' || v_rec.job_id);
            DBMS_OUTPUT.PUT_LINE('Start Date: ' || v_rec.start_date);
            DBMS_OUTPUT.PUT_LINE('End Date:   ' || v_rec.end_date);
            DBMS_OUTPUT.PUT_LINE('Department: ' || v_rec.department_name);
            DBMS_OUTPUT.PUT_LINE('--------------------');
        
    END LOOP;

    CLOSE v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF v_cursor%ISOPEN THEN -- Check if cursor is open before closing
          CLOSE v_cursor;
        END IF;
END;
/



