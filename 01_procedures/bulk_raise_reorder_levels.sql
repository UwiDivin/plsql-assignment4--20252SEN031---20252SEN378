CREATE OR REPLACE PROCEDURE bulk_raise_reorder_levels
IS
    TYPE ids IS TABLE OF products.product_id%TYPE;
    v_ids ids;
BEGIN
    SELECT product_id BULK COLLECT INTO v_ids
    FROM products;

    FORALL i IN 1..v_ids.COUNT
        UPDATE products
        SET reorder_level = reorder_level + 1
        WHERE product_id = v_ids(i);

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' products updated.');
END;
/
