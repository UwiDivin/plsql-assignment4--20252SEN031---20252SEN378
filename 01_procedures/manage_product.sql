CREATE OR REPLACE PROCEDURE manage_product (
    p_id IN NUMBER,
    p_name IN VARCHAR2,
    p_price IN NUMBER
)
IS
BEGIN
    UPDATE products
    SET product_name = p_name,
        unit_price = p_price
    WHERE product_id = p_id;

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Product updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Product not found.');
    END IF;
END;
/
