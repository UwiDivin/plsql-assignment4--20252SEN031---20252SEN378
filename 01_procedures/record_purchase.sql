CREATE OR REPLACE PROCEDURE record_purchase (
    p_product_id IN products.product_id%TYPE,
    p_quantity   IN purchases.quantity_purchased%TYPE,
    p_unit_cost  IN purchases.unit_cost%TYPE,
    p_message    OUT VARCHAR2
) AS
    -- User-defined record: groups the purchase input values.
    TYPE t_purchase_record IS RECORD (
        product_id  products.product_id%TYPE,
        quantity    purchases.quantity_purchased%TYPE,
        unit_cost   purchases.unit_cost%TYPE
    );
    v_purchase t_purchase_record;

    -- %ROWTYPE: stores the complete selected product row.
    v_product products%ROWTYPE;
BEGIN
    SAVEPOINT before_purchase;

    IF p_quantity <= 0 OR p_unit_cost < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Quantity must be positive and unit cost cannot be negative.');
    END IF;

    v_purchase.product_id := p_product_id;
    v_purchase.quantity := p_quantity;
    v_purchase.unit_cost := p_unit_cost;

    SELECT * INTO v_product
    FROM products
    WHERE product_id = v_purchase.product_id
    FOR UPDATE;

    INSERT INTO purchases (product_id, quantity_purchased, purchase_date, unit_cost)
    VALUES (v_purchase.product_id, v_purchase.quantity, SYSDATE, v_purchase.unit_cost);

    UPDATE products
    SET quantity_in_stock = quantity_in_stock + v_purchase.quantity
    WHERE product_id = v_purchase.product_id;

    p_message := 'Purchase recorded. New stock: ' || (v_product.quantity_in_stock + v_purchase.quantity);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK TO before_purchase;
        RAISE_APPLICATION_ERROR(-20002, 'Purchase failed: product ID does not exist.');
    WHEN OTHERS THEN
        ROLLBACK TO before_purchase;
        RAISE;
END record_purchase;
/
