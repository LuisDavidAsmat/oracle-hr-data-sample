CREATE OR REPLACE PACKAGE UTIL_PKG AS
    TYPE t_valid_tables IS TABLE OF VARCHAR2(30) INDEX BY VARCHAR2(30);


    FUNCTION validate_parameter_size(p_size IN NUMBER)
        RETURN BOOLEAN;
        
    FUNCTION is_valid_table(p_table_name IN VARCHAR2) 
        RETURN BOOLEAN;
        
    FUNCTION get_total_records(p_table_name IN VARCHAR2)
        RETURN NUMBER;
    
END UTIL_PKG;
/