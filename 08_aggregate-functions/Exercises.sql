
# ======================== 08章节练习 ========================

# 1.where子句可否使用组函数进行过滤?
# 不可以, WHERE在GROUP BY之前执行, 可以写在HAVING; 并且HAVING中也可写非聚合函数以及使用SELECT中的别名, 但非聚合函数建议WHERE中;


# 2.查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary), MIN(salary), AVG(salary), SUM(salary)/SUM(1), SUM(salary) FROM employees;


# 3.查询各job_id的员工工资的最大值，最小值，平均值，总和
SELECT
    job_id, MAX(salary), MIN(salary), AVG(salary), SUM(salary)
FROM employees
GROUP BY job_id;


# 4.选择具有各个job_id的员工人数
# COUNT()会过滤空值, 即job_id为空的数据已经被过滤
SELECT
    job_id, COUNT(*)
FROM employees
GROUP BY job_id;


# 5.查询员工最高工资和最低工资的差距（DIFFERENCE）
SELECT MAX(salary) - MIN(salary) FROM employees;


# 6.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT
    manager_id, MIN(salary) AS min_salary
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING min_salary > 6000


    # 7.查询所有部门的名字，location_id，员工数量和平均工资，并按平均工资降序
# COUNT(employee_id): 使用COUNT(employee_id)而不是COUNT(*), 因为联表查询时的结果, 没有员工的部门也会有一条记录, 而COUNT(*)或者COUNT(1)是计算行数, 而使用COUNT(列名)可以忽略NULL
SELECT
    dep.department_id,
    dep.department_name,
    location_id,
    COUNT(employee_id),
    AVG( salary )
FROM
    departments dep
        LEFT JOIN employees emp ON emp.department_id = dep.department_id
GROUP BY
    dep.department_id,
    dep.department_name,
    location_id;


# 8.查询每个工种、每个部门的部门名、工种名和最低工资
SELECT
    dep.department_name,
    emp.job_id,
    MIN( salary )
FROM
    departments dep
        LEFT JOIN employees emp ON dep.department_id = emp.department_id
GROUP BY
    dep.department_name,
    emp.job_id;


/*
SELECT
	dep.department_name, emp.job_id, MIN(emp.salary)
FROM departments dep LEFT JOIN employees emp ON dep.department_id = emp.department_id
UNION ALL
SELECT
	dep.department_name, emp.job_id, MIN(emp.salary)
FROM departments dep RIGHT JOIN employees emp ON dep.department_id = emp.department_id
WHERE emp.department_id IS NULL
GROUP BY dep.department_name, emp.job_id;
*/



