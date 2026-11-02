CREATE OR REPLACE PROCEDURE record_purchase (
    p_id IN NUMBER,
    p_qty IN NUMBER,
    p_cost IN NUMBER
)
IS
    v_product products%ROWTYPE;
BEGIN
    SELECT * INTO v_product
    FROM products
    WHERE product_id = p_id;

    INSERT INTO purchases
    VALUES (p_id, p_id, p_qty, SYSDATE, p_cost);

    UPDATE products
    SET quantity_in_stock = quantity_in_stock + p_qty
    WHERE product_id = p_id;

    DBMS_OUTPUT.PUT_LINE('Purchase recorded.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Product not found.');
END;
/
