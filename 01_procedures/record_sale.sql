CREATE OR REPLACE PROCEDURE record_sale (
    p_product_id    IN products.product_id%TYPE,
    p_quantity      IN sales.quantity_sold%TYPE,
    p_selling_price IN sales.selling_price%TYPE,
    p_message       OUT VARCHAR2
) AS
    v_product products%ROWTYPE;
    e_insufficient_stock EXCEPTION;
BEGIN
    SAVEPOINT before_sale;

    IF p_quantity <= 0 OR p_selling_price < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Quantity must be positive and selling price cannot be negative.');
    END IF;

    SELECT * INTO v_product
    FROM products
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF v_product.quantity_in_stock < p_quantity THEN
        RAISE e_insufficient_stock;
    END IF;

    INSERT INTO sales (product_id, quantity_sold, sale_date, selling_price)
    VALUES (p_product_id, p_quantity, SYSDATE, p_selling_price);

    UPDATE products
    SET quantity_in_stock = quantity_in_stock - p_quantity
    WHERE product_id = p_product_id;

    p_message := 'Sale recorded. Remaining stock: ' || (v_product.quantity_in_stock - p_quantity);
EXCEPTION
    WHEN e_insufficient_stock THEN
        ROLLBACK TO before_sale;
        RAISE_APPLICATION_ERROR(-20004, 'Sale failed: insufficient stock.');
    WHEN NO_DATA_FOUND THEN
        ROLLBACK TO before_sale;
        RAISE_APPLICATION_ERROR(-20005, 'Sale failed: product ID does not exist.');
    WHEN OTHERS THEN
        ROLLBACK TO before_sale;
        RAISE;
END record_sale;
/
