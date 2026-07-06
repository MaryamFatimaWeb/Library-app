

-- Library Management System Dara Analysis Project
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10) --FK
          
);
ALTER TABLE employees
ALTER COLUMN salary TYPE FLOAT;

-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);
ALTER TABLE books
ALTER COLUMN rental_price TYPE FLOAT;
ALTER TABLE books
ALTER COLUMN isbn TYPE VARCHAR(20);
ALTER TABLE books
ALTER COLUMN isbn TYPE VARCHAR(20);
ALTER TABLE books
ALTER COLUMN category TYPE VARCHAR(50);
ALTER TABLE books
ALTER COLUMN author TYPE VARCHAR(40);
-- Create table "issued_status"

CREATE TABLE issued_status
(
issued_id VARCHAR(10) PRIMARY KEY,
issued_member_id VARCHAR(10), --FK
issued_book_name VARCHAR(75),
issued_date	DATE,
issued_book_isbn VARCHAR(10), ---FK
issued_emp_id VARCHAR(10) --FK
);
ALTER TABLE issued_status
ALTER COLUMN issued_book_isbn TYPE VARCHAR(40);
-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
);


----- ADD FK
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);


--------branch mem

SELECT issued_id FROM issued_status ORDER BY issued_id;

---------recheck that all csv  are imported successfully

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

--Project Task

--Perform CRUD Operations 
--Create: Inserted sample records into the books table.
--Read: Retrieved and displayed data from various tables.
--Update: Updated records in the employees table.
--Delete: Removed records from the members table as needed.
--Task 1 Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author , publisher )
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

--Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = 'Bharia PH7 RWP'
WHERE member_id = 'C101';
SELECT * FROM members;

--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.


DELETE FROM issued_status
WHERE issued_id = 'IS121'

SELECT * FROM issued_status
WHERE issued_id = 'IS121';

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';


--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT  issued_emp_id,
COUNT (issued_id) as total_books_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT (issued_id) > 1

--3. CTAS (Create Table As Select)
--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
CREATE TABLE books_cnts
AS
SELECT 
      b.isbn,
	  b.book_title,
	  COUNT (ist.issued_id) as no_issed
FROM books as b
JOIN issued_status AS ist
ON ist.issued_book_isbn = b.isbn 
GROUP BY 1,2;

SELECT * FROM
books_cnts; 
--Data Analysis & Findings
--Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books
WHERE category = 'Classic';
--Task 8: Find Total Rental Income by Category: Apply joins because every time the price is increased you can get the exact VALUE

SELECT 
b.category,
SUM(b.rental_price),
COUNT(*)
FROM books as b
JOIN 
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1
--List Members Who Registered in the Last 180 Days:

INSERT INTO members (member_id, member_name, member_address, reg_date)
VALUES
('C121', 'AHSAN', 'NEAR GULBERG 2', '2026-02-27'),
('C122', 'HASSAN', 'G7 MARKAZ', '2026-02-27');
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
--List Employees with Their Branch Manager's Name and their branch details:
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id

---Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;
--Task 12: Retrieve the List of Books Not Yet Returned


SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

































