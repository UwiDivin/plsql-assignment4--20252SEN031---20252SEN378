CREATE OR REPLACE PROCEDURE record_sale (
    p_id IN NUMBER,
    p_qty IN NUMBER,
    p_price IN NUMBER
)
IS
    v_product products%ROWTYPE;
BEGIN
    SELECT *
    INTO v_product
    FROM products
    WHERE product_id = p_id;

    IF p_qty <= 0 OR p_price <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Invalid sale details.');
    END IF;

    IF p_qty > v_product.quantity_in_stock THEN
        RAISE_APPLICATION_ERROR(-20004, 'Not enough stock.');
    END IF;

    INSERT INTO sales
        (product_id, quantity_sold, sale_date, selling_price)
    VALUES
        (p_id, p_qty, SYSDATE, p_price);

    UPDATE products
    SET quantity_in_stock = quantity_in_stock - p_qty
    WHERE product_id = p_id;

    DBMS_OUTPUT.PUT_LINE('Sale recorded successfully.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005, 'Product not found.');
END;
/
