CREATE OR REPLACE PROCEDURE manage_product (
    p_action IN VARCHAR2,
    p_id IN NUMBER,
    p_name IN VARCHAR2,
    p_category IN NUMBER,
    p_supplier IN NUMBER,
    p_price IN NUMBER
)
IS
BEGIN
    IF UPPER(p_action) = 'INSERT' THEN

        INSERT INTO products
            (product_name, category_id, supplier_id,
             unit_price, quantity_in_stock, reorder_level)
        VALUES
            (p_name, p_category, p_supplier, p_price, 0, 5);

        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' product inserted.');

    ELSIF UPPER(p_action) = 'UPDATE' THEN

        UPDATE products
        SET product_name = p_name,
            unit_price = p_price
        WHERE product_id = p_id;

        IF SQL%FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Product updated.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Product not found.');
        END IF;

    ELSIF UPPER(p_action) = 'DELETE' THEN

        DELETE FROM products
        WHERE product_id = p_id;

        IF SQL%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('Product not found.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Product deleted.');
        END IF;

    ELSE
        RAISE_APPLICATION_ERROR(-20006, 'Invalid action.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Operation failed: ' || SQLERRM);
END;
/
