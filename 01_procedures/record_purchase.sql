CREATE OR REPLACE PROCEDURE record_purchase (
    p_id IN NUMBER,
    p_qty IN NUMBER,
    p_cost IN NUMBER
)
IS
    TYPE purchase_record IS RECORD (
        product_id NUMBER,
        quantity NUMBER,
        cost NUMBER
    );

    v_purchase purchase_record;
    v_product products%ROWTYPE;
BEGIN
    IF p_qty <= 0 OR p_cost <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid purchase details');
    END IF;

    SELECT *
    INTO v_product
    FROM products
    WHERE product_id = p_id;

    v_purchase.product_id := p_id;
    v_purchase.quantity := p_qty;
    v_purchase.cost := p_cost;

    INSERT INTO purchases
        (product_id, quantity_purchased, purchase_date, unit_cost)
    VALUES
        (v_purchase.product_id, v_purchase.quantity, SYSDATE, v_purchase.cost);

    UPDATE products
    SET quantity_in_stock = quantity_in_stock + v_purchase.quantity
    WHERE product_id = v_purchase.product_id;

    DBMS_OUTPUT.PUT_LINE('Purchase recorded successfully.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Product not found.');
END;
/
