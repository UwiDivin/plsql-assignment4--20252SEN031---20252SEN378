# Inventory Management System — Database Development with PL/SQL

**Course:** Database Development with PL/SQL (INSY 8311)  
**Assignment:** Group Assignment IV — Records and Collections in Oracle PL/SQL  
**Database:** Oracle Database 21c

## Group members
- Student 1: [Full name] — [Student ID]
- Student 2: [Full name] — [Student ID]

## Application description
This application manages suppliers, categories, products, purchases, and sales. It maintains stock quantities when purchases and sales are recorded and identifies products that have reached their reorder level.

## Repository structure
```text
plsql-assignment4-<studentID1>-<studentID2>/
├── README.md
├── .gitignore
├── 00_schema/
│   ├── 01_create_tables.sql
│   └── 02_insert_sample_data.sql
├── 01_procedures/
│   ├── record_purchase.sql
│   ├── record_sale.sql
│   ├── manage_product.sql
│   ├── list_low_stock.sql
│   └── bulk_raise_reorder_levels.sql
├── 02_functions/
│   ├── get_inventory_value.sql
│   └── get_category_stock.sql
├── 03_tests/
│   ├── test_success_cases.sql
│   └── test_error_cases.sql
├── screenshots/
└── docs/
    └── IMPLEMENTATION_NOTES.md
```

## How to run
Follow the execution order in `docs/IMPLEMENTATION_NOTES.md`. Enable DBMS Output in SQL Developer or run `SET SERVEROUTPUT ON` in SQL*Plus before executing the test scripts.

## Requirements demonstrated
Records, collections, implicit and explicit cursors, `BULK COLLECT`, `FORALL`, stored procedures, functions, exception handling, success tests, and error tests.

## AI disclosure
AI assistance was used to help draft and review parts of the PL/SQL code and documentation. The group members reviewed, tested, and are responsible for understanding and explaining the submitted implementation.
