# HR Database & Analytics | PostgreSQL

**SQL Portfolio Project — Ksenia Samokhina**  
[Русская версия](README_RU.md)

## Project Overview

This project explores how a relational database can support everyday human resources operations and workforce analytics. Using a fictional company dataset, I designed and worked with a PostgreSQL HR database that brings together employee records, organizational structure, positions, compensation, bonuses, skills, and business trips.

The project combines **database development** with **analytical SQL**: from creating related tables and managing records to answering business questions with joins, aggregations, common table expressions (CTEs), views, functions, and window functions.

## Project Objectives

- Organize HR information in a consistent relational data model.
- Connect employees to positions and departments through primary and foreign keys.
- Explore workforce distribution and department-level compensation.
- Identify salary differences, rankings, and employees earning above their department average.
- Practice SQL techniques for data retrieval, transformation, and analysis.

## Tools & Technologies

**PostgreSQL 18** · **pgAdmin 4** · **SQL** · **PL/pgSQL**

## Database Structure

The project uses the `staff2` schema and includes **9 related tables**:

| Table | Purpose |
| --- | --- |
| `employee` | Employee records and position assignments |
| `department` | Departments and their locations |
| `position` | Job positions, salaries, and department assignments |
| `skill` | Catalog of professional skills |
| `position_skills` | Relationships between positions and required skills |
| `accrual` | Employee payroll accruals |
| `bonus_type` | Available bonus categories |
| `emp_bonus` | Bonuses assigned to employees |
| `b_trips` | Employee business trips |

**Core relationship:** `employee` → `position` → `department`. Additional tables model skills, bonuses, payroll accruals, and travel records.

The tested fresh installation contains **11 employees, 6 departments, 9 positions, and 20 accrual records**. All records are synthetic.

## SQL Techniques Demonstrated

- Relational schema design, primary and foreign keys, and `ENUM` types
- `INSERT`, `UPDATE`, filtering, sorting, and data manipulation
- `INNER JOIN`, `LEFT JOIN`, and other join operations
- `GROUP BY`, `HAVING`, `COUNT`, `AVG`, and other aggregates
- Subqueries, CTEs, and SQL views
- PL/pgSQL functions and exception handling
- Window functions including `LAG`, `LEAD`, `DENSE_RANK`, and `NTILE`
- Date-based analysis and conditional expressions

## Analytical Highlights

### 1. Department Salary Analysis

Average base salary calculated for employees assigned to departments:

| Department | Employees | Average base salary |
| --- | ---: | ---: |
| Programming | 3 | 204,000 |
| HR | 2 | 170,000 |
| Marketing | 2 | 160,000 |
| Information Security | 1 | 130,000 |
| Accounting | 2 | 120,000 |

*Values are illustrative, based on fictional data; salary currency is not essential to the analysis.*

### 2. Employees Earning Above Their Department Average

A query combining a **CTE** with `AVG() OVER (PARTITION BY ...)` identifies **4 employees** whose base salaries exceed their department averages: one in HR, one in Marketing, and two in Programming.

### 3. Workforce Distribution and Salary Ranking

The project also examines employee counts across departments and uses window functions to rank employees by salary within their departments. One employee does not have a department assignment through their position, illustrating the importance of handling missing relationships in joins.

These results were checked in pgAdmin using the freshly created test database.

## Repository Files

| File | Description |
| --- | --- |
| [`HR_Database_Analytics.sql`](HR_Database_Analytics.sql) | Complete database setup, sample data, SQL exercises, functions, and analytical queries |
| [`Analytics_After_Restore.sql`](Analytics_After_Restore.sql) | Four read-only analytical queries for the restored database |
| [`HRM_Samokhina_Ksenia.backup`](HRM_Samokhina_Ksenia.backup) | PostgreSQL custom-format database backup |
| [`README_RU.md`](README_RU.md) | Russian-language project documentation |

## How to Run

### Option 1 — Create the Database from Scratch

1. Install PostgreSQL and pgAdmin.
2. Create a **new, empty database** in pgAdmin.
3. Open its **Query Tool** and load `HR_Database_Analytics.sql`.
4. Run the entire script **once**. It creates the `staff2` schema, populates tables, defines database objects, and executes SQL examples.
5. Explore the tables under **Schemas → staff2 → Tables**.

### Option 2 — Restore the Database Backup

1. Create a **separate, empty database**.
2. Right-click it → **Restore** → select `HRM_Samokhina_Ksenia.backup` (Custom format).
3. Explore the `staff2` schema.
4. Open `Analytics_After_Restore.sql` and execute its read-only queries.

**Important:** Do not run the full setup script on a database restored from the backup, or rerun it on an already populated database. The two options are alternatives. The backup represents a different saved state, so some row counts may differ.

## Data Disclaimer

This is an educational portfolio project. **All employee and organizational records are fictional** and do not represent real individuals or a real company.
