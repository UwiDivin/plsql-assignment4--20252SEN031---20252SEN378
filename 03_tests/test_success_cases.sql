SET SERVEROUTPUT ON;

-- Purchase test
BEGIN
    record_purchase(1, 2, 50000);
END;
/

-- Sale test
BEGIN
    record_sale(1, 1, 60000);
END;
/

-- Update product test
BEGIN
    manage_product('UPDATE', 1, 'Samsung Updated', 1, 1, 250000);
END;
/

-- Low stock test
BEGIN
    list_low_stock;
END;
/

-- Bulk processing test
BEGIN
    bulk_raise_reorder_levels;
END;
/

-- Function test
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        'Inventory value: ' || get_inventory_value()
    );
END;
/

-- Collection function test
DECLARE
    v_stock SYS.ODCINUMBERLIST;
BEGIN
    v_stock := get_category_stock(1);

    FOR i IN 1..v_stock.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Stock: ' || v_stock(i));
    END LOOP;
END;
/

-- Check products
SELECT * FROM products;
