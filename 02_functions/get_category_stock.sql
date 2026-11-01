CREATE OR REPLACE FUNCTION get_category_stock (
    p_category_id IN categories.category_id%TYPE
) RETURN NUMBER AS
    -- Nested-table collection stores the stock quantities for the category.
    TYPE t_stock_values IS TABLE OF NUMBER;
    v_stock_values t_stock_values;
    v_total_stock NUMBER := 0;
BEGIN
    SELECT quantity_in_stock
    BULK COLLECT INTO v_stock_values
    FROM products
    WHERE category_id = p_category_id;

    IF v_stock_values.COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'No products were found for this category.');
    END IF;

    FOR i IN 1 .. v_stock_values.COUNT LOOP
        v_total_stock := v_total_stock + v_stock_values(i);
    END LOOP;

    RETURN v_total_stock;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END get_category_stock;
/
