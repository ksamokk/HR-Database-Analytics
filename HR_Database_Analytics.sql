-- HR DATABASE & ANALYTICS | PostgreSQL
-- Author: Ksenia Samokhina (Ксения Самохина)
-- Educational project with fictional employee records.

-- Demonstrates:
-- relational database design
-- primary / foreign keys and ENUM types
-- analytical SQL queries and aggregations
-- JOINs, subqueries, VIEWs and CTEs
-- date / range operations
-- PL/pgSQL functions and exception handling
-- window functions (LAG, LEAD, DENSE_RANK, NTILE)

-- RUN ONCE in a NEW, EMPTY PostgreSQL database using pgAdmin Query Tool.
-- Do not execute this full script on a database restored from the backup.
-- This script includes CREATE, INSERT, UPDATE, functions and analytical SELECTs.
-- PostgreSQL 18; designed for schema staff2.

BEGIN;
CREATE SCHEMA IF NOT EXISTS staff2;
SET search_path TO staff2, public;

CREATE TYPE bonus_names_types AS ENUM
    ('basic', 'intermediate', 'advanced');


-- Create 'department' table
CREATE TABLE department
(
    dep_id smallserial NOT NULL,
    dep_name text NOT NULL,
    address text,
    CONSTRAINT department_pkey PRIMARY KEY (dep_id)
);

-- Create 'position' table
CREATE TABLE position
(
    pos_id smallserial NOT NULL,
    pos_title text NOT NULL,
	base_salary numeric(9,2),
	dep_id smallint,
	CONSTRAINT position_pkey PRIMARY KEY (pos_id),
	CONSTRAINT pos_dep_fkey FOREIGN KEY (dep_id)
        REFERENCES department (dep_id)
);

-- Create 'employee' table
CREATE TABLE employee
(
    emp_id serial NOT NULL,
	name text NOT NULL,
	birth_date date,
	passport_num text,
	phone text,
    pos_id smallint NOT NULL,
    CONSTRAINT employee_pkey PRIMARY KEY (emp_id),
    CONSTRAINT employee_pos_fkey FOREIGN KEY (pos_id)
        REFERENCES position (pos_id)
);

-- Create 'bonus_type' table
CREATE TABLE bonus_type
(
    bonus_id smallserial NOT NULL,
	bonus_name bonus_names_types NOT NULL,
	salary_share numeric(5,2),
    CONSTRAINT bonus_type_pkey PRIMARY KEY (bonus_id)
);

-- Create a table, linking employees and their bonuses
CREATE TABLE emp_bonus
(
    emp_bonus_id serial NOT NULL,
    startdate date NOT NULL,
    end_date date,
    bonus_id smallint NOT NULL,
    emp_id int NOT NULL,
    CONSTRAINT emp_bonus_pkey PRIMARY KEY (emp_bonus_id),
    CONSTRAINT emp_bonus_emp_fkey FOREIGN KEY (emp_id)
        REFERENCES employee (emp_id),
    CONSTRAINT emp_bonus_type_fkey FOREIGN KEY (bonus_id)
        REFERENCES bonus_type (bonus_id)
);
-- Continue in the same schema throughout (original switched to staff).

INSERT INTO department(
	dep_name, address)
	VALUES
	('Marketing Department', 'Kantemirovskaya street, 3'),
	('HR Department', 'Nevsky Prospekt, 64'),
	('Information Security Department', 'Sedova street, 55'),
	('Accounting Department', 'Kantemirovskaya street, 3'),
	('Programming Department', 'Stachek Avenue, 21'),
	('Testing Department', 'Stachek Avenue, 21');

INSERT INTO position(
	pos_title, base_salary, dep_id)
	VALUES 
	('Head of Marketing Department', 200000, 1),
	('Marketing Analyst', 120000, 1),
	('HRD', 190000, 2),
	('Lead Specialist of the HR Department', 150000, 2),
	('System Administrator', 130000, 3),
	('Accountant', 120000, 4),
	('Lead Developer', 210000, 5),
	('Senior Developer', 150000, 5),
	('QA Specialist', 140000, null);
	

INSERT INTO employee(
	name, birth_date, passport_num, phone, pos_id)
	VALUES
	('Ivan Venediktov',     make_date(1983,11,2), '5727 152725', '+7(912)842-48-25', 1),
	('Oleg Vasiliev', 	make_date(1988,3,25), '4457 982645', '+7(912)948-64-79', 2),
	('Anna Melnikova', 	make_date(1995,5,19), '8722 047574', '+7(951)725-20-25', 3),
	('Stepan Ignatov', 	make_date(1991,5,8), '8746 161161', '+7(922)542-04-27', 4),
	('Daria Nikitina', 	make_date(1999,8,12), '2516 489914', '+7(922)454-72-53', 5),
	('Alexander Becker', 	make_date(1985,12,16), '5821 454815', '+7(922)154-17-52', 6),
	('Dmitry Belov', 	make_date(1985,4,6), '7357 274204', '+7(951)544-68-66', 6),
	('Ksenia Frantz', 	make_date(1999,7,24), '7254 354549', '+7(951)124-46-13', 6),
	('Victor Pogudin', 	make_date(1993,11,29), '3778 454437', '+7(922)777-87-14', 7),
	('Valeria Morozova', 	make_date(1991,9,1), '4544 353775', '+7(912)735-24-33', 8),
	('Sofia Besedina', 	make_date(1987,9,22), '8345 044578', '+7(912)454-07-11', 9);

select * from department;

-- 3 Transfer Alexander Becker to the position of " Lead Developer" using the UPDATE query.
-- 3 Обновить данные у сотрудника
update employee
set pos_id = 7
where name = 'Alexander Becker';

select * 
from employee;

-- 4 Use the SELECT query to display a list of the names of all departments of the company.
-- 4 Вывксти список названия отделов
select dep_name 
from department;

-- Display the number of all departments in the company.
-- Посчиать количество отделов
select count(dep_name) as "Number of departments"
from department;

-- Display a list of positions with salaries above 150,000 ₽.
-- Вывести позиции по уровню зарплаты
select pos_title, base_salary 
from position  
where base_salary > 150000;

-- Display the names of the departments and the number of positions in each of them. Leave only those departments with more than 1 position.*/
-- Посчитать количество позиций по отделам и оставить только нужные группы
select dep_name, count(pos_id) as "Number of positions"
from department d
left join position p on d.dep_id = p.dep_id
group by dep_name 
having count(pos_id) > 1
order by count(pos_id) desc;

-- Increase the salary for the position of “Lead Developer” by 10%.
-- Увеличить значение на процент
update position
set base_salary = base_salary * 1.10
where pos_title = 'Lead Developer';

-- 9 Display a list of unique addresses of company departments (i.e. each address should be displayed onle 1 time).
-- Вывести уникальные адреса
select address
from department 
group by address;

-- 10 Print the number of addresses where the company's departments are located.
-- Посчитать количество адресов
select count(distinct address) as "Number of distinct addresses"
from department;
-- Distinct addresses counted above.

-- 11 Output the average salary of positions for the company.
-- Найти среднюю зарплату по всей таблице position
select AVG(base_salary) as "Average salary"
from position;

-- 12 Output the average salary of real employees for each department.
-- Найти среднюю зарплату по отделам
select dep_name as "Department name", AVG(p.base_salary) as "Average salary"
from employee e
join position p on e.pos_id = p.pos_id
join department d on p.dep_id = d.dep_id
group by d.dep_id, d.dep_name;
-- 13 Output the average salary of real employees in the “Programming Department”.
-- Найти среднюю зарплату по конкретному отделу
select AVG(p.base_salary) as "Average salary"
from employee e
join position p on e.pos_id = p.pos_id
join department d on p.dep_id = d.dep_id
where d.dep_name = 'Programming Department';
-- 14 Add information about the types of bonuses: basic – 5%; intermediate – 10%; advanced – 20%.
-- Добавить типы бонусов
insert into bonus_type(bonus_name, salary_share) values ('basic', 5.0), ('intermediate', 10.0), ('advanced', 20.0);
-- Найти нужных сотрудников для назначения бонусов
select name 
from employee 
where name = 'Ksenia Frantz'
or name = 'Anna Melnikova'
or name = 'Alexander Becker';
-- Найти нужные типы бонусов
select bonus_id, bonus_name, salary_share
from bonus_type
where bonus_name in ('basic', 'intermediate', 'advanced');
-- Добавить бонусы сотрудникам
insert into emp_bonus (emp_bonus_id, startdate, end_date, bonus_id, emp_id) values (101, '2026-01-01', NULL, 1, 8), (102, '2026-02-01', NULL, 2, 3), (103, '2026-02-17', NULL, 3, 6);
select *
from employee e
full join emp_bonus on e.emp_id = emp_bonus.emp_id
full join bonus_type on bonus_type.bonus_id = emp_bonus.bonus_id;

-- 1 Print the full name of the employees who were born between January 1, 1990 (inclusive) and January 1, 2000 (not inclusive) along with the date of birth (2 columns).1, 2000 (not inclusive) along with the date of birth (2 columns). Use mathematical operators. Pay attention to the data types to the data types.
-- Вывести сотрудников родившихся в заданный период
select name as "Full names of employees who where born between 1990-01-01 and 2000-01-01", birth_date 
from employee
where birth_date between '1990-01-01' and '1999-12-31';

-- 2 Count how many employees have a surname ending in "ov".
-- Посчитать сотрудников с окончанием 'ov'
select count(name) as "Employees with surname ending in ov"
from employee
where name like '%ov';

-- 3 Print the full names of employees whose names begin with the letter "S".
-- Вывести сотрудников чье имя начинается на 'S'
select name as "Full names of employees whose names begin whith the letter S"
from employee 
where name like 'S%';

-- 4 Print the full names of employees whose names begin with any letter other than "S" and "D".
-- Вывести сотрудников чье имя начинается не на 'S' и не на 'D'
select name as "Full names of employees whose names begin with any letter other than S and D"
from employee
where name not like 'S%' 
and name not like 'D%';

-- 5 Print the average salary for actual employees in the programming and marketing departments along with the department name (2 columns).
-- Посчитать среднюю зарплату по двум отделам
select dep_name as "Department", AVG(base_salary) as "Average salary"
from employee e 
join position p on e.pos_id = p.pos_id
join department d on p.dep_id = d.dep_id
where dep_name = 'Programming Department' or dep_name = 'Marketing Department'
group by d.dep_id;

-- 6 Use cross join to join table employee with itself. Display only rows, where column with names from “first” table employee are not equal to column with names from “second” table employee. (2 columns)
-- Сделать cross join таблицы с самой собой
select e1.name as employee_name, e2.name as other_employee_name
from employee e1
cross join employee e2
where e1.name <> e2.name;

-- 7 Display the current year, month, and day (3 columns).
-- Вывести текущий год, месяц и день
select current_date 
, extract (year from current_date) as year
, extract (month from current_date) as month
, extract (day from current_date) as day;

-- 8 Enter the names of the employees, who has an age between 30 and 35 years (inclusive) for the current day and change data type of age to integer. Set the current day as a variable — you should use it in calculating age of emloyees (2 columns).
-- Вывести сотрудников по возрасту от 30 до 35
with current_date_var as (select current_date as today)
select e.name as "Full name", 
extract(year from age(c.today, e.birth_date))::integer as age 
from employee e
cross join current_date_var c
where extract(year from age(c.today, e.birth_date)) between 30 and 35;

-- 9 Print the number of days that have passed from September 1, 2025 to the current day. Set the current day as a variable.
-- Посчитать дни с 1 сентября 2025 до текущего дня
with current_day as (select current_date as today)
select (c.today - date '2025-09-01') as "Days passed"
from current_day c;

-- 10 Print the number of days that have passed from the beginning of the previous month to the current nday. Set the current day as a variable, and find the previous month using the variable of the current day and the function.
-- Посчитать дни с начала прошлого месяца до текущего дня
select current_date - (date_trunc('month', current_date)::date - interval '1 month')::date
as days_passed;

-- 11 Create a table about business trips called b_trips in the database containing information about the employee, the business trip city, and the business trip period.
-- Создать таблицу командировок
CREATE TABLE IF NOT EXISTS b_trips
(
trip_id serial,
emp_id int,
place varchar(255),
trip_period daterange,
CONSTRAINT b_trip_pkey PRIMARY KEY (trip_id),
CONSTRAINT b_trip_fkey FOREIGN KEY (emp_id)
REFERENCES employee(emp_id)
);

-- 12 Insert the following data into this table:
-- Добавить данные в таблицу командировок
insert into b_trips (emp_id, place, trip_period) values
(1, 'Moscow', '[2024-09-10,2024-09-15]'),
(3, 'Krasnodar', '[2024-11-01,)'),
(7, 'Moscow ', '[2024-10-02,2024-10-09]'),
(8, 'Novosibirsk', '[2024-10-09,2024-10-12]'),
(4, 'Perm', '[2024-09-30,2024-10-05]'),
(11, 'Moscow ', '[2024-10-02,2024-10-09]');

-- 13 Display information about the beginning and end of each business trip in separate columns.
-- Вывести начало и конец командировки
select lower(trip_period) as "Trip starting date", upper(trip_period) as "Trip ending date"
from b_trips;

-- 14 Display the names of the employees who are currently on a business trip and the period of their stay on a business trip (2 columns).
-- Вывести сотрудников, которые сейчас в командировке
select e.name as "Full name", (current_date - lower(bt.trip_period)) as "Trip period"
from b_trips bt
join employee e on bt.emp_id = e.emp_id
where bt.trip_period @> current_date;

-- 15 Take out the information of the employees who were on a business trip to Perm.
-- Вывести сотрудников, ездивших в Пермь
select e.name as "Full name", bt.place as "Place", bt.trip_period as "Trip period"
from b_trips bt
join employee e on bt.emp_id = e.emp_id
where bt.place = 'Perm';

-- 16 Output the number of employees sent on a business trip in each month (count by the date of the start of the business trip).
-- Посчитать количество сотрудников в коммандировках по месяцам
select to_char(lower(trip_period), 'YYYY-MM') as trip_month,
count(*) as "Employees on trip"
from b_trips
group by trip_month
order by trip_month;

-- 1 Display information about employees: full name, position, department name and salary.
-- Вывести информацию о сотрудниках (выборочные данные)
select 
    e.name as full_name,
    p.pos_title as position,
    d.dep_name as department,
    p.base_salary as salary
from employee e
join position p on e.pos_id = p.pos_id
join department d on p.dep_id = d.dep_id;

-- 2 Create a view based on the previous query.
-- Создать представление (view) на основе запроса
create view v_employee_info as
select 
    e.name        as "Full name",
    p.pos_title   as "Position",
    d.dep_name    as "Department",
    p.base_salary as "Salary"
from employee e
join position p on e.pos_id = p.pos_id
left join department d on p.dep_id = d.dep_id;

-- 3 Write the code for the CTE, return select * from <cte_name> as the main query. You will need CTE for the tasks below.
-- Написать CTE и вывести его содержимое
with employee_info as (
    select 
        e.name        as "Full name",
        p.pos_title   as "Position",
        d.dep_name    as "Department",
        p.base_salary as "Salary"
    from employee e
    join position p on e.pos_id = p.pos_id
    left join department d on p.dep_id = d.dep_id
)
select *
from employee_info;

-- 4 Using the CTE or the created view, print the names of employees working in the positions of “Marketing Analyst” or “QA Specialist”, and the departments in which they work (use “coalesce” function if necessary).
-- Вывести сотрудников на двух должностях и их отделы
select 
    "Full name",
    coalesce("Department", 'No department') as "Department"
from v_employee_info
where "Position" in ('Marketing Analyst', 'QA Specialist');

-- 5 Using the CTE or the created view, display information about the number of employees working in each department (excluding employees who are not assigned to any position). The request should return the names of departments and the number of employees in them. Sort the result in descending order (use “coalesce” function if necessary).
-- Посчитать число сотрудников по отделам
select 
    coalesce("Department", 'No department') as "Department",
    count("Full name") as employee_count
from v_employee_info
group by "Department"
having "Department" is not null and count("Full name") > 0
order by employee_count desc;

-- 6 Using the CTE or the created view, display information about employees whose salary is higher or equal to the average salary in the company. The query should return the employee's name, position, department, and salary.
-- Вывести сотрудников с зарплатой не ниже средней по компании
select 
    "Full name",
    "Position",
    coalesce("Department", 'No department') as "Department",
    "Salary"
from v_employee_info
where "Salary" >= (
    select avg("Salary")
    from v_employee_info
);

-- 7 Using the CTE or the created view, display information about the employees of the programming department, whose salary is higher than the salary of any of the employees of the Marketing Department.
-- Вывести програмистов с зарплатой выше любой зарплаты в маркетинге
select 
    "Full name",
    "Position",
    coalesce("Department", 'No department') as "Department",
    "Salary"
from v_employee_info
where "Department" = 'Programming Department'
and "Salary" > any (
    select "Salary"
    from v_employee_info
    where "Department" = 'Marketing Department'
);

-- 8 Display a list of employees, with the number of business trips each of them has been on. The employee has never been on a business trip, display the value 0 for such an employee (use “coalesce” function if necessary).
-- Показать число командировок у каждого сотрудника
select 
    e.name as "Full name",
    coalesce(count(bt.trip_id), 0) as trip_count
from employee e
left join b_trips bt on e.emp_id = bt.emp_id
group by e.name
order by e.name;

-- 9 Display the list of employees born in May.
-- Вывести сотрудников, родившихся в мае
select name as "Full name"
from employee
where extract(month from birth_date) = 5;

-- 10 List the employees who have been on a business trip at least once (use the subquery).
-- Вывести сотрудников, которые были в командировке хотя бы раз
select name as "Full name"
from employee
where emp_id in (
    select emp_id
    from b_trips
);

-- 11 List the employees who have never been on a business trip (use the subquery).
-- Вывести сотрудников, которые никогда не были в командировке
select name as "Full name"
from employee
where emp_id not in (
    select emp_id
    from b_trips
);

-- 12.Display the names of employees from the programming department (query 1) whose salary is less than 180,000 rubles (query 2). Use a combination of the two queries using the union/intersect/except operations.
-- Пересечь два запроса: программисты и зарплата < 180000
select "Full name"
from v_employee_info
where "Department" = 'Programming Department'

intersect

select "Full name"
from v_employee_info
where "Salary" < 180000;

-- Seminar 6

-- First option
create or replace function sum_int (x int, y int) returns int AS $$
  BEGIN 
  return x + y;
  END;
$$ LANGUAGE plpgsql;

select sum_int (9, 12);

-- Second option 
create or replace function sum_int2 (x int, y int, OUT result int)
AS $$
 BEGIN 
 result := x + y;
 END;
$$ LANGUAGE plpgsql;

select sum_int2 (5, 3);

--1.Create a function that returns the number of employees in the company.
-- Создать функцию, которая возвращает число сотрудников в компании
create or replace function emp_count() returns int AS $$
    BEGIN
    return (select count(*) FROM employee);
END;
$$ LANGUAGE plpgsql;

select emp_count();

-- 2 Create a function that returns the number of employees in the company and their average age.
-- Создать функцию, которая возвращает число сотрудников и их средний возраст
create or replace function employee_stats()
returns table (employee_count bigint, average_age numeric) AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(*)::bigint, AVG(EXTRACT(YEAR FROM age(birth_date)))::numeric
    FROM employee;
END;
$$
LANGUAGE plpgsql;

select * from employee_stats();

-- 3 Create a function that adds data to the b_trips table. Function parameters: the employee's name, the date of the start of the business trip, the city of the business trip, and the number of business trip days.
-- Создать функцию для добавления командировки
CREATE OR REPLACE FUNCTION add_business_trip(
    emp_name varchar,
    start_date date,
    city varchar,
    days integer
)
RETURNS void AS
$$
DECLARE
    v_emp_id integer;
BEGIN
    -- Находим emp_id по имени сотрудника
    SELECT emp_id INTO v_emp_id
    FROM employee
    WHERE name = emp_name;
    
    -- Если сотрудник не найден, выдаем ошибку
    IF v_emp_id IS NULL THEN
        RAISE EXCEPTION 'Сотрудник с именем "%" не найден', emp_name;
    END IF;
    
    -- Вставляем запись в b_trips
    INSERT INTO b_trips (emp_id, place, trip_period)
    VALUES (v_emp_id, city, daterange(start_date, start_date + days, '[]'));
END;
$$
LANGUAGE plpgsql;

-- Проверка:
-- 1. Посмотрим всех сотрудников
SELECT name FROM employee;

-- 2. Выберите существующее имя (например, 'Ivan Venediktov', если он есть) и выполните функцию
SELECT add_business_trip('Ivan Venediktov', '2026-03-20', 'Saint Petersburg', 4);

-- 3. Проверим результат (последние добавленные командировки)
SELECT * FROM b_trips ORDER BY trip_id DESC LIMIT 5;



-- 4 The same task 2

-- 5 Create a function that returns the number of employees sent on a business trip in a given month and the average duration of business trips in that month. If the business trip has not been closed yet (there is no end date), use the current date to calculate the duration.
-- Создать функцию, которая возвращает число сотрудников в командировках за месяц и среднюю длительность
CREATE OR REPLACE FUNCTION get_trip_stats_by_month(
    month integer,
    year integer
)
RETURNS TABLE (employee_count bigint, avg_duration numeric) AS
$$
BEGIN
    RETURN QUERY
    SELECT
        COUNT(DISTINCT bt.emp_id)::bigint,
        AVG(
            CASE
                WHEN upper_inf(trip_period) THEN (CURRENT_DATE - lower(trip_period))::numeric
                ELSE (upper(trip_period) - lower(trip_period))::numeric
            END
        )::numeric
    FROM b_trips bt
    WHERE EXTRACT(YEAR FROM lower(bt.trip_period)) = year
      AND EXTRACT(MONTH FROM lower(bt.trip_period)) = month;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM get_trip_stats_by_month(10, 2024);

-- 6 Create database objects to store information about the skills required by employees for a particular position. In addition to the skill name, it is also necessary to store information about the level of this skill for a specific position (low, medium, high).
-- Создать объекты БД для хранения навыков и уровней навыков по должностям
 CREATE TABLE IF NOT EXISTS skill
(
	skill_id serial,
	skill_name varchar(255) NOT NULL,
	CONSTRAINT skill_pkey PRIMARY KEY (skill_id)
);

CREATE TYPE skills_level AS ENUM('low', 'medium', 'high');

CREATE TABLE IF NOT EXISTS position_skills
(
	pos_skill_id serial,
	pos_id smallint NOT NULL,
	skill_id int NOT NULL,
	level skills_level,
	CONSTRAINT pos_skill_pkey PRIMARY KEY (pos_skill_id),
	CONSTRAINT pos_skill_fkey FOREIGN KEY (pos_id) REFERENCES position (pos_id),
	CONSTRAINT pos_skill_fkey_2 FOREIGN KEY (skill_id) REFERENCES skill (skill_id)
);

-- 7 Create the “add_skills” function to insert data about the skills required for the position. Function parameters: job title, skill name, and skill level.
-- Создать функцию 'add_skills' для добавления навыка к должности
CREATE FUNCTION add_skills(skill_param varchar, pos_title_param varchar, level_param skills_level)
RETURNS void AS $$
DECLARE skill_variable int;
BEGIN
	SELECT skill_id
	INTO skill_variable
	FROM skill
	WHERE skill_name = skill_param;
	
	IF skill_variable IS NULL THEN
		INSERT INTO skill (skill_name)
		VALUES (skill_param);
	END IF;
	
	INSERT INTO position_skills (skill_id, pos_id, level)
	VALUES ((SELECT skill_id FROM skill WHERE skill_name = skill_param), 
		   	(SELECT pos_id FROM position WHERE pos_title=pos_title_param),
		   	level_param);
END;
$$
LANGUAGE plpgsql;

-- 8 Insert data using created function:
-- Добавить данные через функцию 'add_skills'
SELECT add_skills('writing SQL-queries', 'Lead Developer', 'medium'); 
SELECT add_skills('writing SQL-queries', 'Senior Developer', 'high'); 
SELECT add_skills('writing SQL-queries', 'QA Specialist', 'low');
SELECT add_skills('knowledge of  Python', 'Lead Developer', 'medium'); 
SELECT add_skills('knowledge of  Python', 'Senior Developer', 'high'); 
SELECT add_skills('knowledge of  Python', 'QA Specialist', 'low'); 
SELECT add_skills('code refactoring', 'Lead Developer', 'high'); 
SELECT add_skills('code refactoring', 'Senior Developer', 'medium'); 
SELECT add_skills('working with version control systems (Git)', 'Lead Developer', 'high'); 
SELECT add_skills('working with version control systems (Git)', 'Senior Developer', 'high');
SELECT add_skills('statistics', 'Marketing Analyst', 'high'); 

-- 9 Create a function that compares the average salary in 2 departments and returns the name of the department with the highest salary. The function must have 2 input parameters (for the name of each department).
-- Создать функцию сравнения средней зарплаты в 2 отделах
CREATE OR REPLACE FUNCTION compare_dept_avg_salary(
    dept_name1 varchar,
    dept_name2 varchar
)
RETURNS varchar AS
$$
DECLARE
    dept_id1 integer;
    dept_id2 integer;
    avg_salary1 numeric;
    avg_salary2 numeric;
BEGIN
    -- Получаем ID отделов по их названиям
    SELECT dep_id INTO dept_id1
    FROM department
    WHERE dep_name = dept_name1;

    SELECT dep_id INTO dept_id2
    FROM department
    WHERE dep_name = dept_name2;

    -- Проверяем, что отделы существуют
    IF dept_id1 IS NULL THEN
        RAISE EXCEPTION 'Отдел "%" не найден', dept_name1;
    END IF;
    IF dept_id2 IS NULL THEN
        RAISE EXCEPTION 'Отдел "%" не найден', dept_name2;
    END IF;

    -- Средняя зарплата в первом отделе (через сотрудников и их должности)
    SELECT COALESCE(AVG(p.base_salary), 0) INTO avg_salary1
    FROM employee e
    JOIN position p ON e.pos_id = p.pos_id
    WHERE p.dep_id = dept_id1;

    -- Средняя зарплата во втором отделе
    SELECT COALESCE(AVG(p.base_salary), 0) INTO avg_salary2
    FROM employee e
    JOIN position p ON e.pos_id = p.pos_id
    WHERE p.dep_id = dept_id2;

    -- Сравниваем и возвращаем результат
    IF avg_salary1 > avg_salary2 THEN
        RETURN dept_name1;
    ELSIF avg_salary2 > avg_salary1 THEN
        RETURN dept_name2;
    ELSE
        RETURN dept_name1 || ' (средние зарплаты равны)';
    END IF;
END;
$$
LANGUAGE plpgsql;

SELECT compare_dept_avg_salary('Marketing Department', 'HR Department');

-- 10 Create a function that compares the average salary in 3 departments and returns the name of the department with the highest salary. The function must have 3 input parameters (for the name of each department).
-- Создать функцию сравнения средней зарплаты в 3 отделах
CREATE OR REPLACE FUNCTION compare_three_depts(
    dept_name1 varchar,
    dept_name2 varchar,
    dept_name3 varchar
)
RETURNS varchar AS
$$
DECLARE
    dept_id1 integer;
    dept_id2 integer;
    dept_id3 integer;
    avg_salary1 numeric;
    avg_salary2 numeric;
    avg_salary3 numeric;
BEGIN
    -- Получаем ID отделов по названиям
    SELECT dep_id INTO dept_id1 FROM department WHERE dep_name = dept_name1;
    SELECT dep_id INTO dept_id2 FROM department WHERE dep_name = dept_name2;
    SELECT dep_id INTO dept_id3 FROM department WHERE dep_name = dept_name3;

    -- Проверяем существование каждого отдела
    IF dept_id1 IS NULL THEN
        RAISE EXCEPTION 'Отдел "%" не найден', dept_name1;
    END IF;
    IF dept_id2 IS NULL THEN
        RAISE EXCEPTION 'Отдел "%" не найден', dept_name2;
    END IF;
    IF dept_id3 IS NULL THEN
        RAISE EXCEPTION 'Отдел "%" не найден', dept_name3;
    END IF;

    -- Средняя зарплата в первом отделе
    SELECT COALESCE(AVG(p.base_salary), 0) INTO avg_salary1
    FROM employee e
    JOIN position p ON e.pos_id = p.pos_id
    WHERE p.dep_id = dept_id1;

    -- Во втором отделе
    SELECT COALESCE(AVG(p.base_salary), 0) INTO avg_salary2
    FROM employee e
    JOIN position p ON e.pos_id = p.pos_id
    WHERE p.dep_id = dept_id2;

    -- В третьем отделе
    SELECT COALESCE(AVG(p.base_salary), 0) INTO avg_salary3
    FROM employee e
    JOIN position p ON e.pos_id = p.pos_id
    WHERE p.dep_id = dept_id3;

    -- Сравниваем и возвращаем отдел с наибольшей средней
    IF avg_salary1 >= avg_salary2 AND avg_salary1 >= avg_salary3 THEN
        RETURN dept_name1;
    ELSIF avg_salary2 >= avg_salary1 AND avg_salary2 >= avg_salary3 THEN
        RETURN dept_name2;
    ELSE
        RETURN dept_name3;
    END IF;
END;
$$
LANGUAGE plpgsql;

SELECT compare_three_depts('Marketing Department', 'HR Department', 'Programming Department');

-- 11 List all the positions that require at least one of the skills required for the position of “lead developer”.
-- Вывести все должности, которым нужен хотя бы один навык 'Lead Developer'
SELECT DISTINCT p.pos_title
FROM position p
JOIN position_skills ps ON p.pos_id = ps.pos_id
WHERE ps.skill_id IN (
    SELECT skill_id
    FROM position_skills
    WHERE pos_id = (SELECT pos_id FROM position WHERE pos_title = 'Lead Developer')
)
ORDER BY p.pos_title;

-- 12 List the positions that require all the skills required for the “lead developer” position. The lead developer himself should not be represented in the sample.
-- Вывести должности, которым нужны все навыки Lead Developer, кроме самого Lead Developer
WITH lead_skills AS (
    -- Все skill_id, необходимые для Lead Developer
    SELECT skill_id
    FROM position_skills
    WHERE pos_id = (SELECT pos_id FROM position WHERE pos_title = 'Lead Developer')
)
SELECT p.pos_title
FROM position p
WHERE p.pos_id != (SELECT pos_id FROM position WHERE pos_title = 'Lead Developer')
  AND NOT EXISTS (                                     -- для каждого навыка Lead Developer
      SELECT 1
      FROM lead_skills ls
      WHERE NOT EXISTS (                               -- проверяем, есть ли он у текущей позиции
          SELECT 1
          FROM position_skills ps
          WHERE ps.pos_id = p.pos_id
            AND ps.skill_id = ls.skill_id
      )
  )
ORDER BY p.pos_title;

-- Seminar 7


-- Continue using staff2 for accruals and window-function examples.

-- Создать таблицу начислений
CREATE TABLE IF NOT EXISTS accrual
(
	acc_id smallserial NOT NULL,
	acc_date timestamp,
	emp_id int NOT NULL,
	amount numeric(10,2),
	CONSTRAINT acc_pkey PRIMARY KEY (acc_id),
	CONSTRAINT acc_fkey FOREIGN KEY (emp_id)
		REFERENCES employee (emp_id)
);


-- Добавить данные в таблицу начислений
INSERT INTO accrual (acc_date, emp_id, amount)
VALUES
('2024-11-22 17:26:55',4,40032.00),
('2024-11-19 09:42:40',6,80450.00),
('2024-11-10 18:06:43',2,30819.00),
('2024-11-08 02:09:33',1,20580.00),
('2024-11-17 14:33:36',6,50639.00),
('2024-11-05 19:19:52',6,40614.00),
('2024-11-17 19:15:46',4,30650.00),
('2024-11-09 11:14:33',5,80603.00),
('2024-11-15 16:32:09',10,40786.00),
('2024-11-17 09:06:50',3,7013.00),
('2024-11-08 05:20:27',9,40451.00),
('2024-11-23 19:17:16',5,60053.00),
('2024-10-28 03:31:00',1,30379.00),
('2024-10-29 20:46:28',1,5090.00),
('2024-11-19 20:16:01',10,60781.00),
('2024-11-10 09:40:57',10,50034.00),
('2024-11-19 08:07:12',5,60225.00),
('2024-11-06 02:07:12',3,60933.00),
('2024-11-01 13:35:05',9,9098.00),
('2024-10-28 21:35:14',6,90275.00)
;


--3.For each employee, output the employee's name, department, salary, average salary for each department, and the difference between the employee's salary and the average salary for their department. 
-- Вывести сотрудника, отдел, зарплату, среднюю зарплату по отделу и отклонение от средней
select
	name,
	dep_name,
	base_salary,
	avg(base_salary) over (partition by d.dep_id) as avg_department,
	base_salary - avg(base_salary) over (partition by d.dep_id) as salary_difference
from employee
join position p on employee.pos_id = p.pos_id
join department d on d.dep_id = p.dep_id;

--4.Create a view that contains information about employee benefits. The view should contain the following columns: the employee's name, the date and time of the accrual, and the amount of the accrual.  
-- Создать view по начислениям сотрудников
create or replace view emp_acc_view as
select name, acc_date, amount
from employee e
left join accrual a on e.emp_id = a.emp_id;
-- 5.	Output the difference between each employee's accrual and the minimum/maximum accrual for that employee.  
-- Показать разницу между текущим начислением и минимумом/максимумом по сотруднику
select 
	name, 
	amount,
	amount - min(amount) over (partition by e.emp_id) as diff_min_acc,
	max(amount) over (partition by e.emp_id) - amount as diff_max_acc
from employee e
join accrual a on e.emp_id = a.emp_id;

--6.Use the window function to calculate the total amount of accruals for each employee.  
-- Посчитать общую сумму начислений по каждому сотруднику
select 
	name, 
	amount,
	sum(amount) over (partition by e.emp_id) as sum_of_acc
from employee e
join accrual a on e.emp_id = a.emp_id;

--7.	For each employee, output the accumulated amount of accruals for each date with accrual. 
-- Показать накопленнуюю сумму начислений по датам 
select 
	name, 
	acc_date,
	amount,
	round(sum(amount) over date_window,2) as cumulative_accrual
from employee e
join accrual a on e.emp_id = a.emp_id
window date_window as (
	partition by e.emp_id order by acc_date);

--8.Calculate the average amount of accruals for each employee in the range of 8 days (8 days before and 8 days after) from the current accrual. Additionally, print the boundaries of each interval.  
-- Посчитать среднее начисление в окне +- 8 дней
select
	name,
	acc_date,
	acc_date - interval '8 days' as eight_days_before, 
	acc_date + interval '8 days' as eight_days_after,
	amount,
	round(avg(amount)over (
	partition by e.emp_id order by acc_date
	range between interval '8 days' preceding and interval '8 days' following),2) as avg_acc_8_days
from employee e
join accrual a on e.emp_id = a.emp_id;

--9.For each employee accrual, output the difference between the current and the previous accrual. 
-- Показать разницу между текущим и предыдущим начислением
select
    name,
    acc_date,
    amount,
    round(amount - lag(amount) over (partition by e.emp_id order by acc_date), 2)
	as diff_acc
from employee e
join accrual a on e.emp_id = a.emp_id;

--10.For each employee accrual, output the difference between the current and the next accrual. 
-- Показать разницу между текущим и следующим начислением 
select
    name,
    acc_date,
    amount,
    round(amount - lead(amount) over (partition by e.emp_id order by acc_date), 2)
	as diff_acc
from employee e
join accrual a on e.emp_id = a.emp_id;

--11.Display a list of employees for whom the average deviation between the current and previous accrual does not exceed 20,000 rubles.  
-- Вывести сотрудников, у которых среднее отклонение было не больше 20 000
with diff_acc_cte as (
    select
        name,
        round(amount - lag(amount) over (partition by e.emp_id order by acc_date), 2) as diff_acc
    from employee e
    join accrual a on e.emp_id = a.emp_id
)
select name
from diff_acc_cte
group by name
having avg(abs(diff_acc)) <= 20000;

--12.For each employee, calculate the average salary of his closest "neighbours" in the department. "Neighbours" are defined by salary size (i.e. the closest employee who gets less and the closest employee who gets more). 
-- Посчитать среднюю зарплату ближайших 'соседей' по отделу
with table_dep as (
    select e.name, p.dep_id, p.base_salary
    from employee e
    join position p on p.pos_id = e.pos_id
)
select
    name,
    dep_id,
    base_salary,
    round(avg(base_salary) over(
        partition by dep_id
        order by base_salary
        rows between 1 preceding and 1 following), 2) as avg_neighbours_salary
from table_dep
order by dep_id, base_salary;

--13.Display the rating of departments by the number of employees working in each of them.  
-- Построить рейтинг отделов по числу сотрудников
select
    d.dep_name,
    count(emp_id) as emp_count,
    dense_rank() over (order by count(*) desc) as rating
from employee e
join position p on p.pos_id = e.pos_id
join department d on d.dep_id = p.dep_id
group by d.dep_id, d.dep_name
order by rating;

--14.	For each employee, withdraw the largest 50% of the accruals.
-- Вывести крупнейшие 50% начислений каждого сотрудника.
with ranked as (
    select
        name,
        acc_date,
        amount,
        ntile(2) over (partition by e.emp_id order by amount desc) as tile
    from employee e
    join accrual a on a.emp_id = e.emp_id
)
select name, amount
from ranked
where tile = 1
order by name, amount desc;


select
    name,
    acc_date,
    amount,
    round(amount - lag(amount) over (partition by e.emp_id order by acc_date), 2)
	as diff_acc
from employee e
join accrual a on e.emp_id = a.emp_id;

COMMIT;
