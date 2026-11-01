# Inventory Management System – Oracle PL/SQL

## 1. Project Description

The **Inventory Management System** is a database application developed using Oracle Database 21c and PL/SQL. It is designed to manage electronic products, suppliers, product categories, purchases, sales, and available stock.

The system helps track inventory operations, update product quantities, identify products with low stock, and calculate inventory values.

This project was developed as part of **Database Development with PL/SQL (INSY 8311) – Assignment IV: Records and Collections in Oracle PL/SQL**.

## 2. Group Members

| Name | Student ID |
|---|---|
| Student 1: UWINGENEYE DIVIN | 20252SEN378 |
| Student 2: BIZIMANA CREDO | 20252SEN031 |

## 3. Technologies Used

- Oracle Database 21c
- Oracle PL/SQL
- SQL Developer
- GitHub

## 4. Database Design

The application consists of five main tables:

| Table | Description |
|---|---|
| `SUPPLIERS` | Stores supplier information. |
| `CATEGORIES` | Stores product categories. |
| `PRODUCTS` | Stores product details, prices, and stock quantities. |
| `PURCHASES` | Records products purchased from suppliers. |
| `SALES` | Records products sold to customers. |

### Relationships

- A supplier can supply multiple products.
- A category can contain multiple products.
- A product can have multiple purchase records.
- A product can have multiple sales records.

## 5. PL/SQL Concepts Implemented

This project demonstrates the following concepts required by the assignment:

- **Records:** User-defined records and `%ROWTYPE` for storing and processing related data.
- **Collections:** PL/SQL collections for handling multiple values and records.
- **Implicit Cursors:** `SQL%ROWCOUNT`, `SQL%FOUND`, and `SQL%NOTFOUND` with database operations.
- **Explicit Cursors:** Retrieving and processing multiple records using `OPEN`, `FETCH`, and `CLOSE`.
- **Bulk Processing:** `BULK COLLECT` and `FORALL` for processing multiple records efficiently.
- **Stored Procedures:** Performing inventory operations such as recording purchases, sales, and managing products.
- **Stored Functions:** Calculating inventory values and retrieving category stock information.
- **Exception Handling:** Handling predefined exceptions, user-defined exceptions, and application errors using `RAISE_APPLICATION_ERROR`.

## 6. Repository Structure

```text
plsql-assignment4-<studentID1>-<studentID2>/
│
├── README.md
├── .gitignore
│
├── 00_schema/
│   ├── 01_create_tables.sql
│   └── 02_insert_sample_data.sql
│
├── 01_procedures/
│   ├── record_purchase.sql
│   ├── record_sale.sql
│   ├── manage_product.sql
│   ├── list_low_stock.sql
│   └── bulk_raise_reorder_levels.sql
│
├── 02_functions/
│   ├── get_inventory_value.sql
│   └── get_category_stock.sql
│
├── 03_tests/
│   ├── test_success_cases.sql
│   └── test_error_cases.sql
│
├── screenshots/
│
└── docs/
    └── IMPLEMENTATION_NOTES.md
```

## 7. How to Run the Project

### Requirements

- Oracle Database 21c installed and running.
- An Oracle database user with the necessary privileges.
- Oracle SQL Developer or SQL*Plus.

### Execution Steps

1. Connect to your Oracle database using the project database user.
2. Run `00_schema/01_create_tables.sql` to create the database tables.
3. Run `00_schema/02_insert_sample_data.sql` to insert sample records.
4. Compile the stored procedures in `01_procedures/`.
5. Compile the stored functions in `02_functions/`.
6. Execute `03_tests/test_success_cases.sql`.
7. Execute `03_tests/test_error_cases.sql`.
8. Verify the results and save screenshots of successful and error-handling tests.

**Note:** If the database tables and sample records have already been created, do not run the schema and sample-data scripts again.

## 8. Testing

The project includes two test scripts:

- `test_success_cases.sql`: Demonstrates successful execution of the application's operations.
- `test_error_cases.sql`: Demonstrates exception handling and responses to invalid operations.

Screenshots of the actual execution results are stored in the `screenshots/` directory.

## 9. Implementation and Performance Notes

The system uses PL/SQL records and collections to organize and process related data. Explicit cursors allow controlled retrieval of multiple rows, while implicit cursor attributes help determine the results of database operations.

Bulk processing with `BULK COLLECT` and `FORALL` reduces repeated SQL-to-PL/SQL context switching when processing multiple records. Exception handling helps the application respond appropriately to invalid operations and unexpected database errors.

Further implementation details are provided in `docs/IMPLEMENTATION_NOTES.md`.

## 10. Academic Integrity and AI Disclosure

AI assistance was used to support understanding, code organization, documentation, and debugging during the development of this project. The group members are responsible for reviewing, testing, understanding, and explaining all submitted code.

## 11. Conclusion

The Inventory Management System demonstrates how Oracle PL/SQL can be used to develop a practical database application. It combines database management operations with records, collections, cursors, bulk processing, stored procedures, functions, and exception handling.
