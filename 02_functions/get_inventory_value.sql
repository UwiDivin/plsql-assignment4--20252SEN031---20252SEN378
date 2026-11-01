CREATE OR REPLACE FUNCTION get_inventory_value
RETURN NUMBER AS
    v_total_value NUMBER(18,2);
BEGIN
    SELECT NVL(SUM(quantity_in_stock * unit_price), 0)
    INTO v_total_value
    FROM products;

    RETURN v_total_value;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20009, 'Could not calculate total inventory value: ' || SQLERRM);
END get_inventory_value;
/
