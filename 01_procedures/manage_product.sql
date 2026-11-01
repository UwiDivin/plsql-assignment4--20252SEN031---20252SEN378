CREATE OR REPLACE PROCEDURE manage_product (
    p_action       IN VARCHAR2,
    p_product_id   IN products.product_id%TYPE DEFAULT NULL,
    p_product_name IN products.product_name%TYPE DEFAULT NULL,
    p_category_id  IN products.category_id%TYPE DEFAULT NULL,
    p_supplier_id  IN products.supplier_id%TYPE DEFAULT NULL,
    p_unit_price   IN products.unit_price%TYPE DEFAULT NULL,
    p_quantity     IN products.quantity_in_stock%TYPE DEFAULT NULL,
    p_reorder      IN products.reorder_level%TYPE DEFAULT NULL,
    p_message      OUT VARCHAR2
) AS
BEGIN
    CASE UPPER(p_action)
        WHEN 'INSERT' THEN
            INSERT INTO products (product_name, category_id, supplier_id,
                                  unit_price, quantity_in_stock, reorder_level)
            VALUES (p_product_name, p_category_id, p_supplier_id,
                    p_unit_price, NVL(p_quantity, 0), NVL(p_reorder, 5));

            IF SQL%FOUND THEN
                p_message := 'INSERT successful. Rows affected: ' || SQL%ROWCOUNT;
            END IF;

        WHEN 'UPDATE' THEN
            UPDATE products
            SET product_name = NVL(p_product_name, product_name),
                unit_price = NVL(p_unit_price, unit_price),
                quantity_in_stock = NVL(p_quantity, quantity_in_stock),
                reorder_level = NVL(p_reorder, reorder_level)
            WHERE product_id = p_product_id;

            IF SQL%FOUND THEN
                p_message := 'UPDATE successful. Rows affected: ' || SQL%ROWCOUNT;
            ELSE
                p_message := 'UPDATE found no product. SQL%NOTFOUND = TRUE.';
            END IF;

        WHEN 'DELETE' THEN
            DELETE FROM products WHERE product_id = p_product_id;

            IF SQL%NOTFOUND THEN
                p_message := 'DELETE found no product. SQL%NOTFOUND = TRUE.';
            ELSE
                p_message := 'DELETE successful. Rows affected: ' || SQL%ROWCOUNT;
            END IF;

        ELSE
            RAISE_APPLICATION_ERROR(-20006, 'Invalid action. Use INSERT, UPDATE, or DELETE.');
    END CASE;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20007, 'Product insert failed because a unique constraint was violated.');
    WHEN OTHERS THEN
        RAISE;
END manage_product;
/
