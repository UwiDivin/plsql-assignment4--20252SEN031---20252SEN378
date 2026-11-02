CREATE OR REPLACE PROCEDURE bulk_raise_reorder_levels
IS
    TYPE product_list IS TABLE OF products.product_id%TYPE;

    v_ids product_list;

    e_bulk_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_bulk_error, -24381);
BEGIN
    SELECT product_id
    BULK COLLECT INTO v_ids
    FROM products;

    IF v_ids.COUNT > 0 THEN

        FORALL i IN 1..v_ids.COUNT SAVE EXCEPTIONS
            UPDATE products
            SET reorder_level = reorder_level + 1
            WHERE product_id = v_ids(i);

        DBMS_OUTPUT.PUT_LINE(
            SQL%ROWCOUNT || ' products updated.'
        );

    ELSE
        DBMS_OUTPUT.PUT_LINE('No products found.');
    END IF;

EXCEPTION
    WHEN e_bulk_error THEN
        DBMS_OUTPUT.PUT_LINE('Some updates failed.');

        FOR i IN 1..SQL%BULK_EXCEPTIONS.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Error code: ' ||
                SQL%BULK_EXCEPTIONS(i).ERROR_CODE
            );
        END LOOP;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
