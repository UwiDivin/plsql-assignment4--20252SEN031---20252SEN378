-- Sample data. Run once, after 01_create_tables.sql.

INSERT INTO suppliers (supplier_name, phone, email)
VALUES ('Kigali Tech Supplies', '0788000001', 'sales@kigalitech.example');
INSERT INTO suppliers (supplier_name, phone, email)
VALUES ('East Africa Electronics', '0788000002', 'info@eae.example');

INSERT INTO categories (category_name) VALUES ('Mobile Phones');
INSERT INTO categories (category_name) VALUES ('Accessories');
INSERT INTO categories (category_name) VALUES ('Computer Equipment');

INSERT INTO products (product_name, category_id, supplier_id, unit_price, quantity_in_stock, reorder_level)
SELECT 'Samsung Galaxy A15', c.category_id, s.supplier_id, 250000, 15, 5
FROM categories c CROSS JOIN suppliers s
WHERE c.category_name = 'Mobile Phones' AND s.supplier_name = 'Kigali Tech Supplies';

INSERT INTO products (product_name, category_id, supplier_id, unit_price, quantity_in_stock, reorder_level)
SELECT 'USB-C Charger', c.category_id, s.supplier_id, 12000, 15, 5
FROM categories c CROSS JOIN suppliers s
WHERE c.category_name = 'Accessories' AND s.supplier_name = 'East Africa Electronics';

INSERT INTO products (product_name, category_id, supplier_id, unit_price, quantity_in_stock, reorder_level)
SELECT 'Wireless Mouse', c.category_id, s.supplier_id, 18000, 15, 5
FROM categories c CROSS JOIN suppliers s
WHERE c.category_name = 'Computer Equipment' AND s.supplier_name = 'Kigali Tech Supplies';

INSERT INTO purchases (product_id, quantity_purchased, purchase_date, unit_cost)
SELECT product_id, 20, SYSDATE - 10, unit_price * 0.75 FROM products;

INSERT INTO sales (product_id, quantity_sold, sale_date, selling_price)
SELECT product_id, 5, SYSDATE - 2, unit_price FROM products;

COMMIT;
