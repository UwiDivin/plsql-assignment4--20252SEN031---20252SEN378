# Implementation Notes — Inventory Management System

## Application
The Inventory Management System tracks suppliers, product categories, products, purchases, and sales. A purchase increases product stock; a sale decreases product stock after checking that enough units are available.

## PL/SQL concepts demonstrated
- **User-defined record:** `record_purchase` groups product ID, quantity, and unit cost in one record.
- **%ROWTYPE:** `record_purchase`, `record_sale`, and `list_low_stock` use row structures based on table/cursor definitions.
- **Collections:** `bulk_raise_reorder_levels` uses an associative array; `get_category_stock` uses a nested-table collection.
- **Implicit cursors:** `manage_product` uses `SQL%FOUND`, `SQL%NOTFOUND`, and `SQL%ROWCOUNT` after INSERT, UPDATE, and DELETE.
- **Explicit cursor:** `list_low_stock` explicitly opens, fetches, and closes a cursor.
- **Bulk processing:** `bulk_raise_reorder_levels` uses `BULK COLLECT` to fetch IDs and `FORALL ... SAVE EXCEPTIONS` to update rows.
- **Procedures and functions:** purchase/sale/product-management procedures and inventory-value/category-stock functions perform practical operations.
- **Exceptions:** predefined exceptions (`NO_DATA_FOUND`, `TOO_MANY_ROWS`, `DUP_VAL_ON_INDEX`), a user-defined insufficient-stock exception, `RAISE_APPLICATION_ERROR`, and bulk DML error handling are demonstrated.

## Bulk-processing performance
`BULK COLLECT` fetches multiple product IDs into a PL/SQL collection in one operation. `FORALL` sends the corresponding DML statements to the SQL engine in batches. This reduces repeated PL/SQL-to-SQL context switches compared with processing each row using an individual UPDATE inside a loop. `SAVE EXCEPTIONS` allows Oracle to attempt the remaining DML operations and makes individual failures available through `SQL%BULK_EXCEPTIONS`.

## Execution order
1. Run `00_schema/01_create_tables.sql` only if the tables do not already exist.
2. Run `00_schema/02_insert_sample_data.sql` only once after table creation.
3. Compile every `.sql` file in `01_procedures/`.
4. Compile every `.sql` file in `02_functions/`.
5. Run `03_tests/test_success_cases.sql`.
6. Run `03_tests/test_error_cases.sql`.
7. Capture genuine SQL Developer/SQL*Plus output screenshots in `screenshots/`.

## Important testing note
The success test changes data and commits. Run it only when you are ready to retain those test changes, or restore your sample data before repeating it. The error test is designed to report expected errors without terminating the whole test block.
