# 📚 Library Management System — Data Analysis SQL Project

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Data%20Analysis-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)
![Level](https://img.shields.io/badge/Level-Intermediate-yellow?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

---

## 📖 Project Overview

This project presents a fully designed and implemented **Library Management System** built with **PostgreSQL**. It covers the complete data lifecycle — from relational database design and schema creation to data insertion, querying, and structured SQL-based data analysis.

The system simulates a real-world library environment where books are issued to members, managed by employees across multiple branches, and returned — with all table relationships enforced through **foreign key constraints**.

> 🎯 **Goal:** Demonstrate practical SQL skills including database design, data manipulation, multi-table joins, aggregations, subqueries, and CTAS operations — suitable for a professional data analyst portfolio.

---

## 🖼️ Project Visuals

### 📌 Entity Relationship Diagram (ERD)
![ERD](ERD%20DB.JPG)

### 📌 Database Schema
![Schema](Library%20Management%20System.png)

---

## 🗄️ Database Schema

The system is built on **6 interrelated tables:**

| Table | Description |
|-------|-------------|
| `branch` | Library branch locations and manager assignments |
| `employees` | Staff details including salary and branch assignment |
| `members` | Registered library member profiles |
| `books` | Full book inventory with ISBN, category, and rental price |
| `issued_status` | Tracks every book issued to a member by an employee |
| `return_status` | Tracks book returns linked to issued records |

### 🔗 Relationship Map

```
branch ──────────< employees
                       │
          ┌────────────┘
          │
          └──< issued_status >────── members
                    │
                 books
                    │
             return_status
```

---

## 📂 Repository Structure

```
Library_Management_System_Data_Analysis_SQL_Project/
│
├── 📄 library_managment_system.sql     -- Schema: table creation & FK constraints
├── 📄 insert_queries.sql               -- All data insertion queries
├── 📊 books.csv                        -- Books dataset
├── 📊 branch.csv                       -- Branch dataset
├── 📊 employees.csv                    -- Employees dataset
├── 📊 members.csv                      -- Members dataset
├── 📊 issued_status.csv                -- Issued status dataset
├── 📊 return_status.csv                -- Return status dataset
├── 🖼️  ERD DB.JPG                       -- Entity Relationship Diagram
├── 🖼️  Library Management System.png    -- Schema visual
└── 📄 README.md                        -- Project documentation
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **PostgreSQL 17** | Relational database engine |
| **pgAdmin 4** | Query execution & database management |
| **SQL** | DDL, DML, DQL — full data lifecycle |
| **CSV Files** | Raw data source for all 6 tables |

---

## 🚀 Project Phases & Tasks

---

### 🏗️ Phase 1 — Database Design & Setup (DDL)

Designed and created all 6 tables with appropriate data types, primary keys, and foreign key constraints to maintain referential integrity.

```sql
-- Branch Table
CREATE TABLE branch (
    branch_id   VARCHAR(10) PRIMARY KEY,
    manager_id  VARCHAR(10),
    branch_address VARCHAR(30),
    contact_no  VARCHAR(15)
);

-- Employees Table
CREATE TABLE employees (
    emp_id    VARCHAR(10) PRIMARY KEY,
    emp_name  VARCHAR(30),
    position  VARCHAR(30),
    salary    FLOAT,
    branch_id VARCHAR(10)  -- FK → branch
);

-- Members Table
CREATE TABLE members (
    member_id      VARCHAR(10) PRIMARY KEY,
    member_name    VARCHAR(30),
    member_address VARCHAR(30),
    reg_date       DATE
);

-- Books Table
CREATE TABLE books (
    isbn         VARCHAR(20) PRIMARY KEY,
    book_title   VARCHAR(80),
    category     VARCHAR(50),
    rental_price FLOAT,
    status       VARCHAR(10),
    author       VARCHAR(40),
    publisher    VARCHAR(30)
);

-- Issued Status Table
CREATE TABLE issued_status (
    issued_id        VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10),   -- FK → members
    issued_book_name VARCHAR(75),
    issued_date      DATE,
    issued_book_isbn VARCHAR(40),   -- FK → books
    issued_emp_id    VARCHAR(10)    -- FK → employees
);

-- Return Status Table
CREATE TABLE return_status (
    return_id        VARCHAR(10) PRIMARY KEY,
    issued_id        VARCHAR(30),   -- FK → issued_status
    return_book_name VARCHAR(80),
    return_date      DATE,
    return_book_isbn VARCHAR(50)
);
```

**Foreign Key Constraints Applied:**

```sql
ALTER TABLE issued_status ADD CONSTRAINT fk_members
    FOREIGN KEY (issued_member_id) REFERENCES members(member_id);

ALTER TABLE issued_status ADD CONSTRAINT fk_books
    FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn);

ALTER TABLE issued_status ADD CONSTRAINT fk_employees
    FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id);

ALTER TABLE employees ADD CONSTRAINT fk_branch
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id);

ALTER TABLE return_status ADD CONSTRAINT fk_issued_status
    FOREIGN KEY (issued_id) REFERENCES issued_status(issued_id);
```

---

### ✏️ Phase 2 — CRUD Operations (DML)

Performed complete **Create, Read, Update, Delete** operations across tables.

---

#### ✅ Task 1 — Insert a New Book Record

```sql
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES (
    '978-1-60129-456-2',
    'To Kill a Mockingbird',
    'Classic',
    6.00,
    'yes',
    'Harper Lee',
    'J.B. Lippincott & Co.'
);
```

---

#### ✅ Task 2 — Update a Member's Address

```sql
UPDATE members
SET member_address = 'Bharia PH7 RWP'
WHERE member_id = 'C101';
```

---

#### ✅ Task 3 — Delete a Record from Issued Status

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

---

#### ✅ Task 4 — Retrieve All Books Issued by a Specific Employee

```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';
```

---

#### ✅ Task 5 — Members Who Issued More Than One Book

```sql
SELECT 
    issued_emp_id,
    COUNT(issued_id) AS total_books_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;
```

---

### 📊 Phase 3 — Data Analysis & Findings (DQL)

---

#### ✅ Task 6 — CTAS: Book Issue Count Summary Table

> Created a new summary table showing how many times each book has been issued.

```sql
CREATE TABLE books_cnts AS
SELECT 
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) AS no_issued
FROM books AS b
JOIN issued_status AS ist ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;

SELECT * FROM books_cnts;
```

---

#### ✅ Task 7 — Retrieve All Books in a Specific Category

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

---

#### ✅ Task 8 — Total Rental Income by Category

> Uses JOIN to get accurate rental income — prices are always pulled from the live books table.

```sql
SELECT 
    b.category,
    SUM(b.rental_price) AS total_income,
    COUNT(*)            AS total_issued
FROM books AS b
JOIN issued_status AS ist ON ist.issued_book_isbn = b.isbn
GROUP BY b.category
ORDER BY total_income DESC;
```

---

#### ✅ Task 9 — Members Registered in the Last 180 Days

```sql
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

---

#### ✅ Task 10 — Employees with Branch Manager Details

> Self-join on the employees table to show each employee alongside their branch manager's name.

```sql
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b     ON e1.branch_id = b.branch_id
JOIN employees AS e2 ON e2.emp_id = b.manager_id;
```

---

#### ✅ Task 11 — CTAS: Premium Books (Rental Price Above Threshold)

```sql
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

SELECT * FROM expensive_books;
```

---

#### ✅ Task 12 — Books Not Yet Returned

> Uses LEFT JOIN with NULL check to find all books currently still with members.

```sql
SELECT 
    ist.*,
    rs.return_id
FROM issued_status AS ist
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
```

---

## 📋 Tasks Summary Table

| # | Task | Category | Key SQL Concept |
|---|------|----------|-----------------|
| 1 | Insert new book record | CRUD | `INSERT INTO` |
| 2 | Update member address | CRUD | `UPDATE SET` |
| 3 | Delete issued record | CRUD | `DELETE FROM` |
| 4 | Books issued by specific employee | Read | `SELECT WHERE` |
| 5 | Members with more than one issue | Analysis | `GROUP BY`, `HAVING` |
| 6 | Book issue count summary | CTAS | `CREATE TABLE AS SELECT` |
| 7 | Books by category | Analysis | `SELECT WHERE` |
| 8 | Rental income by category | Analysis | `JOIN`, `SUM`, `GROUP BY` |
| 9 | Recently registered members | Analysis | `INTERVAL`, `CURRENT_DATE` |
| 10 | Employees with manager details | Analysis | `Self JOIN` |
| 11 | High-value books table | CTAS | `CREATE TABLE AS SELECT` |
| 12 | Unreturned books | Analysis | `LEFT JOIN`, `IS NULL` |

---

## ▶️ How to Run This Project

**Step 1 — Clone the Repository**
```bash
git clone https://github.com/AhsanTestOps/Library_Management_System_Data_Analysis_SQL_Project.git
cd Library_Management_System_Data_Analysis_SQL_Project
```

**Step 2 — Create the Database**

Open pgAdmin 4 and create a new database:
```sql
CREATE DATABASE library_system_management;
```

**Step 3 — Run Schema Script**
```sql
-- Execute this file to create all tables and constraints
\i library_managment_system.sql
```

**Step 4 — Insert the Data**
```sql
-- Execute this file to populate all tables
\i insert_queries.sql
```

**Step 5 — Verify Data**
```sql
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM members;
SELECT * FROM issued_status;
SELECT * FROM return_status;
```

**Step 6 — Run Analysis Queries**

Open the query tool in pgAdmin and run any task queries from this README to explore the data.

---

## 💡 Key Insights & Findings

- 📌 Tracked complete **book issuance and return lifecycle** across multiple branches
- 📌 Identified **most active employees** by number of books processed
- 📌 Calculated **total rental revenue** broken down by book category
- 📌 Pinpointed **books never returned** using LEFT JOIN null filtering
- 📌 Analyzed **member registration trends** over a rolling 180-day window
- 📌 Built **summary tables using CTAS** for faster reporting

---

## 🤝 Connect With Me

If you found this project helpful, feel free to connect or give feedback!

[![GitHub](https://img.shields.io/badge/GitHub-AhsanTestOps-black?style=for-the-badge&logo=github)](https://github.com/AhsanTestOps)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

⭐ **If you found this project useful, please consider giving it a star!** ⭐

*Made with dedication and lots of SQL queries 💻*

</div>
