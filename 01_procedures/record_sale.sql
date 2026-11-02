CREATE OR REPLACE PROCEDURE record_sale (
    p_id IN NUMBER,
    p_qty IN NUMBER,
    p_price IN NUMBER
)
IS
    v_stock NUMBER;
BEGIN
    SELECT quantity_in_stock INTO v_stock
    FROM products
    WHERE product_id = p_id;

    IF p_qty <= 0 OR p_qty > v_stock THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid quantity or insufficient stock.');
    END IF;

    INSERT INTO sales
    VALUES (p_id, p_id, p_qty, SYSDATE, p_price);

    UPDATE products
    SET quantity_in_stock = quantity_in_stock - p_qty
    WHERE product_id = p_id;

    DBMS_OUTPUT.PUT_LINE('Sale recorded.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Product not found.');
END;
/
