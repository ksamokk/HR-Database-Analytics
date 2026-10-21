-- Read-only analytics for the restored backup (staff2 schema).
-- Run this file after restoring HRM_Samokhina_Ksenia.backup.

SELECT
    COALESCE(d.dep_name, 'Unassigned') AS department,
    COUNT(e.emp_id) AS employee_count
FROM staff2.employee e
LEFT JOIN staff2.position p
    ON e.pos_id = p.pos_id
LEFT JOIN staff2.department d
    ON p.dep_id = d.dep_id
GROUP BY COALESCE(d.dep_name, 'Unassigned')
ORDER BY employee_count DESC, department;

SELECT
    d.dep_name AS department,
    COUNT(e.emp_id) AS employee_count,
    ROUND(AVG(p.base_salary), 2) AS avg_base_salary,
    MIN(p.base_salary) AS min_base_salary,
    MAX(p.base_salary) AS max_base_salary
FROM staff2.department d
JOIN staff2.position p
    ON d.dep_id = p.dep_id
JOIN staff2.employee e
    ON p.pos_id = e.pos_id
GROUP BY d.dep_id, d.dep_name
ORDER BY avg_base_salary DESC;

SELECT
    e.name AS employee,
    COALESCE(d.dep_name, 'Unassigned') AS department,
    p.pos_title AS position,
    p.base_salary,
    DENSE_RANK() OVER (
        PARTITION BY d.dep_id
        ORDER BY p.base_salary DESC
    ) AS salary_rank_in_department
FROM staff2.employee e
LEFT JOIN staff2.position p
    ON e.pos_id = p.pos_id
LEFT JOIN staff2.department d
    ON p.dep_id = d.dep_id
ORDER BY department, salary_rank_in_department;

WITH employee_salaries AS (
    SELECT
        e.emp_id,
        e.name AS employee,
        d.dep_name AS department,
        p.pos_title AS position,
        p.base_salary,
        ROUND(
            AVG(p.base_salary) OVER (
                PARTITION BY d.dep_id
            ), 2
        ) AS department_avg_salary
    FROM staff2.employee e
    JOIN staff2.position p
        ON e.pos_id = p.pos_id
    JOIN staff2.department d
        ON p.dep_id = d.dep_id
)
SELECT
    employee,
    department,
    position,
    base_salary,
    department_avg_salary,
    ROUND(
        base_salary - department_avg_salary, 2
    ) AS salary_above_average
FROM employee_salaries
WHERE base_salary > department_avg_salary
ORDER BY salary_above_average DESC;
