CREATE OR REPLACE PROCEDURE list_low_stock AS
    CURSOR c_low_stock IS
        SELECT product_id, product_name, quantity_in_stock, reorder_level
        FROM products
        WHERE quantity_in_stock <= reorder_level
        ORDER BY product_name;

    v_item c_low_stock%ROWTYPE;
BEGIN
    OPEN c_low_stock;
    LOOP
        FETCH c_low_stock INTO v_item;
        EXIT WHEN c_low_stock%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || v_item.product_id ||
            ' | Product: ' || v_item.product_name ||
            ' | Stock: ' || v_item.quantity_in_stock ||
            ' | Reorder level: ' || v_item.reorder_level
        );
    END LOOP;
    CLOSE c_low_stock;
EXCEPTION
    WHEN OTHERS THEN
        IF c_low_stock%ISOPEN THEN
            CLOSE c_low_stock;
        END IF;
        RAISE;
END list_low_stock;
/
