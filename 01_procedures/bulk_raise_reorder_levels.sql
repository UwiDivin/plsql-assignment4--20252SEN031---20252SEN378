CREATE OR REPLACE PROCEDURE bulk_raise_reorder_levels (
    p_rows_updated OUT NUMBER
) AS
    -- Associative array collection for the selected product IDs.
    TYPE t_product_ids IS TABLE OF products.product_id%TYPE INDEX BY PLS_INTEGER;
    v_product_ids t_product_ids;

    e_bulk_errors EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_bulk_errors, -24381);
BEGIN
    p_rows_updated := 0;

    -- BULK COLLECT fetches all low-stock product IDs into the collection.
    SELECT product_id
    BULK COLLECT INTO v_product_ids
    FROM products
    WHERE quantity_in_stock <= reorder_level;

    IF v_product_ids.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No low-stock products found.');
        RETURN;
    END IF;

    -- FORALL sends the updates to SQL in batches instead of one row at a time.
    FORALL i IN INDICES OF v_product_ids SAVE EXCEPTIONS
        UPDATE products
        SET reorder_level = reorder_level + 1
        WHERE product_id = v_product_ids(i);

    FOR i IN INDICES OF v_product_ids LOOP
        p_rows_updated := p_rows_updated + SQL%BULK_ROWCOUNT(i);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || p_rows_updated);
EXCEPTION
    WHEN e_bulk_errors THEN
        FOR i IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Bulk error at collection index ' || SQL%BULK_EXCEPTIONS(i).ERROR_INDEX ||
                ': ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE)
            );
        END LOOP;
        RAISE_APPLICATION_ERROR(-20008, 'One or more bulk updates failed.');
    WHEN OTHERS THEN
        RAISE;
END bulk_raise_reorder_levels;
/
