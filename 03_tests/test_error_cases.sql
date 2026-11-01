SET SERVEROUTPUT ON;

DECLARE
    v_message VARCHAR2(4000);
    v_product_id products.product_id%TYPE;
    v_single_id products.product_id%TYPE;
BEGIN
    SELECT MIN(product_id) INTO v_product_id FROM products;

    -- User-defined exception in record_sale: request more than available stock.
    BEGIN
        record_sale(v_product_id, 999999, 1000, v_message);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Expected sale error: ' || SQLERRM);
    END;

    -- NO_DATA_FOUND is handled and converted to a meaningful application error.
    BEGIN
        record_purchase(-999999, 2, 1000, v_message);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Expected missing-product error: ' || SQLERRM);
    END;

    -- SQL%NOTFOUND demonstration: UPDATE a product ID that does not exist.
    BEGIN
        manage_product('UPDATE', p_product_id => -999999,
                       p_product_name => 'Does not exist', p_message => v_message);
        DBMS_OUTPUT.PUT_LINE(v_message);
    END;

    -- TOO_MANY_ROWS predefined exception demonstration.
    BEGIN
        SELECT product_id INTO v_single_id FROM products;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Expected TOO_MANY_ROWS: query returned more than one product.');
    END;

    -- Invalid action demonstrates RAISE_APPLICATION_ERROR.
    BEGIN
        manage_product('REMOVE', p_product_id => v_product_id, p_message => v_message);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Expected invalid-action error: ' || SQLERRM);
    END;
END;
/
