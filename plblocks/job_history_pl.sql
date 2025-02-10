SET SERVEROUTPUT ON;
DECLARE
  v_job_histories_cursor SYS_REFCURSOR;
  v_total_records NUMBER;
  v_total_pages NUMBER;
  v_rec job_history%ROWTYPE;  
BEGIN
  -- Call the stored procedure
  SP_GET_ALL_JOB_HISTORIES(
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