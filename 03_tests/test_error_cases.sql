SET SERVEROUTPUT ON;

-- Product does not exist
BEGIN
    record_purchase(9999, 2, 50000);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Insufficient stock
BEGIN
    record_sale(1, 999999, 50000);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Invalid quantity
BEGIN
    record_purchase(1, 0, 50000);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
