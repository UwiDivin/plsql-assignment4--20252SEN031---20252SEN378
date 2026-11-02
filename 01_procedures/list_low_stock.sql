CREATE OR REPLACE PROCEDURE list_low_stock
IS
    CURSOR c_products IS
        SELECT product_name, quantity_in_stock
        FROM products
        WHERE quantity_in_stock <= reorder_level;

    v_name products.product_name%TYPE;
    v_qty products.quantity_in_stock%TYPE;
BEGIN
    OPEN c_products;

    LOOP
        FETCH c_products INTO v_name, v_qty;
        EXIT WHEN c_products%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_name || ' - ' || v_qty);
    END LOOP;

    CLOSE c_products;
END;
/
