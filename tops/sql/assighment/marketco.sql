create database MarketCo;

use MarketCo;

SET SQL_SAFE_UPDATES = 0

create table company (
companyid int primary key,
companyname varchar(45),
street varchar(45),
city varchar(45),
state varchar(20),
zip varchar(10) );

iNSERT INTO  company  VALUES
(1, 'Urban Outfitters, Inc.', '500 Fashion Ave', 'New York', 'NY', '10001'),
(2, 'Toll Brothers', '250 Maple St', 'Philadelphia', 'PA', '19103'),
(3, 'MarketCo Ltd', '123 Main St', 'Chicago', 'IL', '60601'),
(4, 'TechNova', '890 Silicon Blvd', 'San Jose', 'CA', '95112'),
(5, 'GreenWorks', '77 Green St', 'Austin', 'TX', '73301'),
(6, 'FutureVision', '321 Vision Rd', 'Seattle', 'WA', '98101');

select * from company;


-- 1) Statement to create the Contact table
create table contact (
contactid int Primary key,
companyid int,
firstname varchar(45),
lastname varchar(45),
street varchar(45),
city varchar(45),
zip varchar(10),
ismain boolean,
email varchar(45),
phone varchar(12),
foreign key(companyid) references company(companyid)
 );
 
 INSERT INTO contact VALUES
(1, 1, 'Jack', 'Lee', '45 West St', 'New York', '10002', TRUE, 'jack.lee@urban.com', '2125551234'),
(2, 2, 'Dianne', 'Connor', '67 Pine St', 'Philadelphia',  '19104', FALSE, 'dianne.connor@toll.com', '2155559876'),
(3, 3, 'Michael', 'Scott', '172 Paper Rd', 'Scranton',  '18503', TRUE, 'michael.scott@marketco.com', '5705551212'),
(4, 4, 'Sarah', 'Nguyen', '90 Tech St', 'San Jose',  '95112', FALSE, 'sarah.nguyen@technova.com', '4085552345'),
(5, 5, 'Robert', 'King', '11 Lake View', 'Austin',  '73301', TRUE, 'robert.king@greenworks.com', '5125558765'),
(6, 6, 'Linda', 'Garcia', '77 Vision Dr', 'Seattle',  '98101', FALSE, 'linda.garcia@futurevision.com', '2065559988');

select * from contact;
 
 -- 2) Statement to create the Employee table 
 create table employee (
 employeeid int primary key,
 firstname varchar(45),
 lastname varchar(45),
 salary  decimal(10,2),
 hiredate date,
 jobtitle varchar(45),
 email varchar(45),
 phone varchar(12) );
 
 INSERT INTO  employee VALUES
(1, 'Lesley', 'Bland', 60000, '2019-04-15', 'Sales Manager', 'lesley.bland@marketco.com', '2155551111'),
(2, 'John', 'Doe', 55000, '2020-06-01', 'Account Executive', 'john.doe@marketco.com', '2155552222'),
(3, 'Emily', 'Clark', 70000, '2018-03-22', 'HR Manager', 'emily.clark@marketco.com', '2155553333'),
(4, 'Mark', 'Brown', 80000, '2017-07-10', 'IT Director', 'mark.brown@marketco.com', '2155554444'),
(5, 'Sophia', 'White', 50000, '2021-01-12', 'Marketing Associate', 'sophia.white@marketco.com', '2155555555'),
(6, 'David', 'Wilson', 62000, '2019-09-18', 'Project Manager', 'david.wilson@marketco.com', '2155556666');
 
 select * from employee;
 
 -- 3)Statement to create the ContactEmployee table
 create table contactemployee (
 contactemployeeid int primary key,
 contactid int,
 employeeid int,
 contactdate date,
 description varchar(100),
 foreign key(contactid) references contact(contactid),
 foreign key(employeeid) references employee(employeeid));
 
 INSERT INTO contactemployee VALUES
(1, 1, 1, '2022-02-15', 'Meeting with Jack Lee from Urban Outfitters'),
(2, 2, 2, '2022-03-10', 'Call with Dianne Connor at Toll Brothers'),
(3, 3, 3, '2022-04-05', 'Discussion with Michael Scott about new contract'),
(4, 4, 4, '2022-05-12', 'Tech support discussion with Sarah Nguyen'),
(5, 5, 5, '2022-06-20', 'Sustainability collaboration with Robert King'),
(6, 6, 6, '2022-07-08', 'Future partnership talk with Linda Garcia');

select * from contactemployee;

-- 4) In the Employee table, the statement that changes Lesley Bland’s phone number to 215-555-8800

UPDATE employee
SET phone = '2155558800'
WHERE firstname = 'Lesley' AND lastname = 'Bland';
 
-- 5) In the Company table, the statement that changes the name of “Urban Outfitters, Inc.” to “Urban Outfitters” 

UPDATE Company
SET CompanyName = 'Urban Outfitters'
WHERE CompanyName = 'Urban Outfitters, Inc.';

-- 6) In ContactEmployee table, the statement that removes Dianne Connor’s contact event with Jack Lee (one statement).

DELETE FROM ContactEmployee
WHERE ContactID = (SELECT ContactID FROM Contact 
                   WHERE FirstName = 'Dianne' AND LastName = 'Connor')
  AND EmployeeID = (SELECT EmployeeID FROM Employee 
                    WHERE FirstName = 'Jack' AND LastName = 'Lee');
                    
--  7) Write the SQL SELECT query that displays the names of the employees that
-- have contacted Toll Brothers (one statement). Run the SQL SELECT query in
-- MySQL Workbench. Copy the results below as well. 

SELECT DISTINCT e.FirstName, e.LastName
FROM Employee e
JOIN ContactEmployee ce ON e.EmployeeID = ce.EmployeeID
JOIN Contact c ON ce.ContactID = c.ContactID
JOIN Company co ON c.CompanyID = co.CompanyID
WHERE co.CompanyName = 'Toll Brothers';

-- 8) What is the significance of “%” and “_” operators in the LIKE statement? 
-- 1. The % wildcard represents any sequence of characters (including none).
-- Example: WHERE Name LIKE 'S%' → finds names like Sam, Smith, Singh.
-- 2. The _ wildcard represents exactly one character.
-- Example: WHERE Name LIKE 'M_n' → finds Man, Men, but not Moon.

-- 9) Explain normalization in the context of databases. 
-- Normalization is the process of organizing data in a database to reduce redundancy and improve data integrity.
-- It involves dividing large tables into smaller related tables and defining relationships between them. 
-- The main goals are to eliminate duplicate data, ensure logical data storage, and make updates more efficient.
-- Normalization is typically done in stages called normal forms (1NF, 2NF, 3NF, etc.), each with specific rules.

-- 10) What does a join in MySQL mean? 
-- A JOIN in MySQL is used to combine rows from two or more tables based on a related column between them.
-- It allows you to retrieve data that is spread across multiple tables. Common types of joins include:
-- INNER JOIN – returns only matching rows from both tables.
-- LEFT JOIN – returns all rows from the left table and matching rows from the right.
-- RIGHT JOIN – returns all rows from the right table and matching rows from the left.
-- FULL JOIN (not directly supported in MySQL) – returns all rows when there is a match in one of the tables.

-- 11)What do you understand about DDL, DCL, and DML in MySQL? 
-- DDL (Data Definition Language):
-- Used to define and manage database structures like tables and schemas.
-- Examples: CREATE, ALTER, DROP.
-- DML (Data Manipulation Language):
-- Used to manage data within tables.
-- Examples: INSERT, UPDATE, DELETE, SELECT.
-- DCL (Data Control Language):
-- Used to control access to data and permissions.
-- Examples: GRANT, REVOKE.

-- 12) What is the role of the MySQL JOIN clause in a query, and what are some common types of joins?
-- The JOIN clause in MySQL is used to combine data from two or more tables based on a related column. 
-- It helps retrieve related information stored in different tables.
-- Common types of JOINs:
-- INNER JOIN: Returns only the rows with matching values in both tables.
-- LEFT JOIN (or LEFT OUTER JOIN): Returns all rows from the left table and matching rows from the right table.
-- RIGHT JOIN (or RIGHT OUTER JOIN): Returns all rows from the right table and matching rows from the left table.
-- FULL JOIN: Returns all rows when there is a match in either table (not directly supported in MySQL, but can be emulated).