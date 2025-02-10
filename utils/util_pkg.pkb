CREATE OR REPLACE PACKAGE BODY UTIL_PKG AS
    FUNCTION validate_parameter_size(p_size IN NUMBER) RETURN BOOLEAN IS
    BEGIN
        IF p_size <= 0 THEN
          RAISE_APPLICATION_ERROR(-20001, 'Size must be greater than zero');
        ELSIF p_size > 1000 THEN
          RAISE_APPLICATION_ERROR(-20002, 'Size cannot exceed 1000');
        END IF;
        
        -- Validation passes
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in validate_page_size: ' || SQLERRM);
        RETURN FALSE; -- Return false if an error occurs
    END validate_parameter_size;
    
    
    FUNCTION is_valid_table(p_table_name IN VARCHAR2) RETURN BOOLEAN IS
        v_valid_tables t_valid_tables;
    BEGIN
        v_valid_tables('job_history') := 'job_history';
        v_valid_tables('employees') := 'employees';
        v_valid_tables('departments') := 'departments';
       
        RETURN v_valid_tables.EXISTS(LOWER(p_table_name));
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in is_valid_table: ' || SQLERRM);
        RETURN FALSE;  
        
    END is_valid_table;
    
    FUNCTION get_total_records(p_table_name IN VARCHAR2) RETURN NUMBER IS
        v_count NUMBER := 0;
        v_sql VARCHAR2(4000);
        v_safe_table_name VARCHAR2(128);
    BEGIN
         
        IF p_table_name IS NULL OR LENGTH(TRIM(p_table_name)) = 0 THEN
            RAISE_APPLICATION_ERROR(-20005, 'Invalid table name: NULL or empty string');
        END IF;
    
        IF NOT is_valid_table(p_table_name) THEN
            RAISE_APPLICATION_ERROR(-20005, 'Invalid table name');
        END IF;
       
        v_safe_table_name := DBMS_ASSERT.SQL_OBJECT_NAME(TRIM(LOWER(p_table_name)));
        
        v_sql := 'SELECT COUNT(*) FROM ' || v_safe_table_name;
        
        EXECUTE IMMEDIATE v_sql INTO v_count;
        
        RETURN v_count;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in get_total_records: ' || SQLERRM);
            RAISE_APPLICATION_ERROR(-20006, 
                'Error getting record count: ' || SUBSTR(SQLERRM, 1, 200));
    END get_total_records;

END UTIL_PKG;
/
