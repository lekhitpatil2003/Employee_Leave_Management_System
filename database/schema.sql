-- ============================================================================
-- Employee Leave Management System (ELMS) - Database Schema
-- ============================================================================
-- This script reflects the EXACT current live structure of the `elms`
-- database (verified against `DESCRIBE` output for every table: admin,
-- department, employee, leave_type, leave_request).
--
-- Use this to set up a fresh copy of the database, or as the authoritative
-- schema reference/backup for this project.
--
-- Run with:  mysql -u root -p < schema.sql
-- ============================================================================

CREATE DATABASE IF NOT EXISTS elms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE elms;

-- Drop in dependency order (leave_request depends on employee)
DROP TABLE IF EXISTS leave_request;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS leave_type;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS admin;

-- ----------------------------------------------------------------------------
-- admin
-- ----------------------------------------------------------------------------
CREATE TABLE admin (
    admin_id  INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email_id  VARCHAR(100) NOT NULL,
    username  VARCHAR(50)  NOT NULL,
    password  VARCHAR(255) NOT NULL,
    UNIQUE KEY email_id (email_id),
    UNIQUE KEY username (username)
);

-- ----------------------------------------------------------------------------
-- department
-- ----------------------------------------------------------------------------
CREATE TABLE department (
    dept_id     INT AUTO_INCREMENT PRIMARY KEY,
    dept_name   VARCHAR(100) NOT NULL,
    dept_code   VARCHAR(20)  NOT NULL,
    description VARCHAR(255) NULL,
    UNIQUE KEY dept_name (dept_name),
    UNIQUE KEY dept_code (dept_code)
);

-- ----------------------------------------------------------------------------
-- leave_type
-- ----------------------------------------------------------------------------
CREATE TABLE leave_type (
    leave_id    INT AUTO_INCREMENT PRIMARY KEY,
    leave_name  VARCHAR(100) NOT NULL,
    leave_code  VARCHAR(20)  NOT NULL,
    description VARCHAR(255) NULL,
    UNIQUE KEY leave_name (leave_name),
    UNIQUE KEY leave_code (leave_code)
);

-- ----------------------------------------------------------------------------
-- employee
-- ----------------------------------------------------------------------------
CREATE TABLE employee (
    sr_no         INT AUTO_INCREMENT PRIMARY KEY,
    emp_id        VARCHAR(20)  NOT NULL,
    name          VARCHAR(100) NOT NULL,
    gender        VARCHAR(10)  NOT NULL,
    email         VARCHAR(100) NOT NULL,
    mobile_no     VARCHAR(15)  NOT NULL,
    department    VARCHAR(100) NOT NULL,
    user_name     VARCHAR(50)  NOT NULL,
    password      VARCHAR(255) NOT NULL,
    leave_balance INT NOT NULL DEFAULT 20,
    profile_pic   VARCHAR(255) NULL,
    added_date    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY emp_id (emp_id),
    UNIQUE KEY email (email),
    UNIQUE KEY user_name (user_name)
);

-- ----------------------------------------------------------------------------
-- leave_request
-- ----------------------------------------------------------------------------
CREATE TABLE leave_request (
    leave_id      INT AUTO_INCREMENT PRIMARY KEY,
    emp_id        INT NOT NULL,
    leave_type    VARCHAR(100) NOT NULL,
    from_date     DATE NOT NULL,
    to_date       DATE NOT NULL,
    total_days    INT NOT NULL,
    reason        VARCHAR(500) NULL,
    status        VARCHAR(20) NOT NULL DEFAULT 'Pending',
    admin_remarks VARCHAR(500) NULL,
    applied_date  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_date  TIMESTAMP NULL DEFAULT NULL,

    KEY idx_leave_request_emp (emp_id),
    KEY idx_leave_request_status (status),

    CONSTRAINT fk_leave_request_employee
        FOREIGN KEY (emp_id) REFERENCES employee (sr_no)
        ON DELETE CASCADE
);

-- ============================================================================
-- OPTIONAL: seed data for a fresh install
-- Uncomment and adjust if you're setting up a brand-new database rather than
-- restoring the structure of an existing one.
-- ============================================================================

-- Admin: username = admin | password = Admin@123 (PBKDF2-hashed)
-- INSERT INTO admin (full_name, email_id, username, password) VALUES
-- ('System Administrator', 'admin@elms.com', 'admin',
--  '65536:8q9W+/uRTFTIW/ak3ck0Pg==:608TTlgm97jWm9udevWiOSXgu4HbhSuAregjykukprQ=');

-- INSERT INTO department (dept_name, dept_code, description) VALUES
-- ('Human Resources', 'HR', 'Handles recruitment, onboarding and employee relations'),
-- ('Engineering', 'ENG', 'Product development and software engineering'),
-- ('Finance', 'FIN', 'Accounting, payroll and financial planning'),
-- ('Sales', 'SAL', 'Business development and client relations');

-- INSERT INTO leave_type (leave_name, leave_code, description) VALUES
-- ('Casual Leave', 'CL', 'Short leave for personal reasons'),
-- ('Sick Leave', 'SL', 'Leave for illness or medical appointments'),
-- ('Earned Leave', 'EL', 'Accrued leave that can be planned in advance'),
-- ('Maternity Leave', 'ML', 'Leave for childbirth and childcare');

-- Sample employee: email = john@elms.com | password = Employee@123 (PBKDF2-hashed)
-- INSERT INTO employee (emp_id, name, gender, email, mobile_no, department, user_name, password, leave_balance) VALUES
-- ('EMP001', 'John Doe', 'Male', 'john@elms.com', '9876543210', 'Engineering', 'johndoe',
--  '65536:wq2diZQZUiMQ0yW0lHWLPQ==:ALUhgnWLOhKnwnA2RgKeklJ+5BO2JpC8dNH6jAh8PsM=', 20);

-- ============================================================================
-- VERIFICATION
-- ============================================================================
-- SHOW TABLES;
-- DESCRIBE admin; DESCRIBE department; DESCRIBE leave_type;
-- DESCRIBE employee; DESCRIBE leave_request;
