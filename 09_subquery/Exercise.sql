
# ======================== 09章节练习 ========================

#1.查询和Zlotkey相同部门的员工姓名和工资
SELECT last_name, salary, department_id
FROM employees
WHERE department_id = (
    SELECT department_id FROM employees WHERE last_name = 'Zlotkey'
)

    #2.查询工资比公司平均工资高的员工的员工号，姓名和工资。
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
)

    #3.选择工资大于所有JOB_ID = 'SA_MAN'的员工的工资的员工的last_name, job_id, salary
SELECT last_name, job_id, salary
FROM employees
WHERE salary > ALL(
    SELECT salary FROM employees WHERE job_id = 'SA_MAN'
)

    #4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT employee_id, last_name, department_id
FROM employees
WHERE department_id IN (
    SELECT department_id FROM employees WHERE last_name LIKE '%u%'
)

    #5.查询在部门的location_id为1700的部门工作的员工的员工号
SELECT employee_id
FROM employees
WHERE department_id IN(
    SELECT department_id FROM departments WHERE location_id = 1700
)

    #6.查询管理者是King的员工姓名和工资
# 写法一:
SELECT last_name, salary, manager_id
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE last_name = 'King'
);
# 写法二: 这里确定了是管理者的King, 排除了普通员工的King
SELECT last_name, salary, manager_id
FROM employees
WHERE manager_id = (
    SELECT employee_id
    FROM employees
    WHERE last_name = 'King'
      AND employee_id IN(
        SELECT DISTINCT mgr.employee_id
        FROM employees mgr
                 INNER JOIN employees emp
                            ON mgr.employee_id = emp.manager_id
    )
);

#7.查询工资最低的员工信息: last_name, salary
SELECT last_name, salary
FROM employees
WHERE salary = (
    SELECT MIN(salary) FROM employees
);

#8.查询平均工资最低的部门信息
# 方式一:
SELECT *
FROM departments
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) = (
        SELECT MIN(avg_salary)
        FROM (
                 SELECT department_id, AVG(salary) avg_salary
                 FROM employees
                 GROUP BY department_id
             ) dep_avg
    )
);

# 方式二:
SELECT *
FROM departments
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) <= ALL (
        SELECT AVG(salary) avg_salary
        FROM employees
        GROUP BY department_id
    )
);

# 方式三:
SELECT *
FROM departments
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) ASC
    LIMIT 0, 1
    )

    # 方式四:
SELECT d1.*
FROM departments d1, (
    SELECT department_id, AVG(salary) avg_salary
    FROM employees
    GROUP BY department_id
    ORDER BY avg_salary ASC
        LIMIT 0, 1
) d2
WHERE d1.department_id = d2.department_id

    #9.查询平均工资最低的部门信息和该部门的平均工资（相关子查询）
# 在第八题的基础上, 在SELECT查询的列中, 添加一个相关子查询即可
# 方式一:
SELECT dep.*,(
    SELECT AVG(salary)
    FROM employees emp
    WHERE dep.department_id = emp.department_id
) AS dep_avg_salary
FROM departments dep
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) = (
        SELECT MIN(avg_salary)
        FROM (
                 SELECT department_id, AVG(salary) avg_salary
                 FROM employees
                 GROUP BY department_id
             ) dep_avg
    )
);


#10.查询平均工资最高的 job 信息
# 和第八题一样, 有第八题的部门和最低平均工资, 改为job和最高平均工资; 同样三种写法
# 方式一:
SELECT *
FROM jobs
WHERE job_id = (
    SELECT job_id
    FROM employees
    GROUP BY job_id
    HAVING AVG(salary) = (
        SELECT MAX(avg_salary)
        FROM (
                 SELECT job_id, AVG(salary) avg_salary
                 FROM employees
                 GROUP BY job_id
             ) dep_avg
    )
);

# 方式二:
SELECT *
FROM jobs
WHERE job_id = (
    SELECT job_id
    FROM employees
    GROUP BY job_id
    HAVING AVG(salary) >= ALL(
        SELECT AVG(salary) avg_salary
        FROM employees
        GROUP BY job_id
    )
);

# 方式三:
SELECT *
FROM jobs
WHERE job_id = (
    SELECT job_id
    FROM employees
    GROUP BY job_id
    ORDER BY AVG(salary) DESC
    LIMIT 0, 1
    );

# 方式四:
SELECT j1.*
FROM jobs j1, (
    SELECT job_id
    FROM employees
    GROUP BY job_id
    ORDER BY AVG(salary) DESC
        LIMIT 0, 1
) j2
WHERE j1.job_id = j2.job_id;
