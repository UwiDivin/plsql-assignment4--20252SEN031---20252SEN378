SET SERVEROUTPUT ON;

DECLARE
    v_product_id products.product_id%TYPE;
    v_category_id categories.category_id%TYPE;
    v_supplier_id suppliers.supplier_id%TYPE;
    v_message VARCHAR2(4000);
    v_rows NUMBER;
BEGIN
    SELECT MIN(product_id) INTO v_product_id FROM products;

    -- Test a purchase: inserts purchase history and increases stock.
    record_purchase(v_product_id, 3, 10000, v_message);
    DBMS_OUTPUT.PUT_LINE(v_message);

    -- Test a sale: inserts sales history and decreases stock.
    record_sale(v_product_id, 1, 15000, v_message);
    DBMS_OUTPUT.PUT_LINE(v_message);

    -- Test implicit-cursor UPDATE and its row count.
    manage_product('UPDATE', p_product_id => v_product_id,
                   p_product_name => 'Updated Product Name', p_message => v_message);
    DBMS_OUTPUT.PUT_LINE(v_message);

    -- Test implicit-cursor INSERT. Use existing valid category and supplier IDs.
    SELECT MIN(category_id) INTO v_category_id FROM categories;
    SELECT MIN(supplier_id) INTO v_supplier_id FROM suppliers;
    manage_product('INSERT', p_product_name => 'Temporary Test Product',
                   p_category_id => v_category_id, p_supplier_id => v_supplier_id,
                   p_unit_price => 5000, p_quantity => 10, p_reorder => 2,
                   p_message => v_message);
    DBMS_OUTPUT.PUT_LINE(v_message);

    -- Put one product below its reorder level so the cursor and bulk update
    -- have rows to process during this test.
    UPDATE products SET quantity_in_stock = 1 WHERE product_id = v_product_id;

    -- Test explicit cursor.
    DBMS_OUTPUT.PUT_LINE('Low-stock products:');
    list_low_stock;

    -- Test BULK COLLECT + FORALL.
    bulk_raise_reorder_levels(v_rows);
    DBMS_OUTPUT.PUT_LINE('Bulk rows updated: ' || v_rows);

    -- Test both functions.
    DBMS_OUTPUT.PUT_LINE('Total inventory value: ' || get_inventory_value());
    DBMS_OUTPUT.PUT_LINE('Stock in first category: ' || get_category_stock(v_category_id));

    -- Test implicit-cursor DELETE using the temporary row.
    SELECT MAX(product_id) INTO v_product_id
    FROM products WHERE product_name = 'Temporary Test Product';
    manage_product('DELETE', p_product_id => v_product_id, p_message => v_message);
    DBMS_OUTPUT.PUT_LINE(v_message);

    COMMIT;
END;
/
