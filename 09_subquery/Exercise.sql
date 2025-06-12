
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

#11.查询平均工资高于公司平均工资的部门有哪些?
SELECT department_id, AVG(salary) dep_avg_salary
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING dep_avg_salary > (
    SELECT AVG(salary) FROM employees
)

    #12.查询出公司中所有 manager 的详细信息
# 方式一: 自连接
SELECT DISTINCT mgr.employee_id, mgr.last_name
FROM employees mgr
         INNER JOIN employees emp
                    ON mgr.employee_id = emp.manager_id;

# 方式二: 子查询
SELECT employee_id, last_name
FROM employees
WHERE employee_id IN (
    SELECT DISTINCT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
)

    # 方式三: 相关子查询
SELECT employee_id, last_name
FROM employees mgr
WHERE EXISTS (
    SELECT 1
    FROM employees emp
    WHERE mgr.employee_id = emp.manager_id
)

    #13.各个部门中 最高工资中最低的那个部门的 最低工资是多少?
# 与第八题, 第十题类似
# 方式一:
SELECT MIN(salary)
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE salary = (
        SELECT MIN(max_salary)
        FROM(
                SELECT department_id, MAX(salary) max_salary
                FROM employees
                GROUP BY department_id
            ) dep_max
    )
);
# 方式二:
SELECT MIN(salary)
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING MAX(salary) <= ALL(
        SELECT MAX(salary) max_salary
        FROM employees
        GROUP BY department_id
    )

);
# 方式三:
SELECT MIN(salary)
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY MAX(salary)
    LIMIT 0,1
    );

# 方式四:
SELECT MIN(e1.salary)
FROM employees e1,(
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY MAX(salary) ASC
        LIMIT 0,1
) e2
WHERE e1.department_id = e2.department_id

    #14.查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary
# 方式一:
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id IN(
    SELECT manager_id
    FROM departments
             # department_id IN 可以换成 ANY
WHERE department_id IN(
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) = (
    SELECT MAX(avg_salary)
    FROM(
    SELECT department_id, AVG(salary) avg_salary
    FROM employees
    GROUP BY department_id
    ) dep_avg
    )
    )
    );
# 方式二:
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id IN(
    SELECT manager_id
    FROM departments
    WHERE department_id IN(
        SELECT department_id
        FROM employees
        GROUP BY department_id
        HAVING AVG(salary) >= ALL(
            SELECT AVG(salary) avg_salary
            FROM employees
            GROUP BY department_id
        )
    )
);

# 方式三
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id IN(
    SELECT manager_id
    FROM departments
    WHERE department_id IN(
        SELECT department_id
        FROM employees
        GROUP BY department_id
        HAVING AVG(salary) = (
            SELECT AVG(salary)
            FROM employees
            GROUP BY department_id
            ORDER BY AVG(salary) DESC
    LIMIT 0,1
    )
    )
    );

# 方式四:
SELECT last_name, department_id, email, salary
FROM employees e1,(
    SELECT manager_id
    FROM departments
    WHERE department_id = (
        SELECT department_id
        FROM employees
        GROUP BY department_id
        ORDER BY AVG(salary) DESC
        LIMIT 0,1
)
    ) e2
WHERE e1.employee_id = e2.manager_id

    #15. 查询部门的部门号，其中不包括job_id是"ST_CLERK"的部门号
# 方式一:
SELECT department_id
FROM employees
WHERE job_id != 'ST_CLERK';

# 方式二:
SELECT department_id
FROM departments
WHERE department_id NOT IN(
    SELECT department_id
    FROM employees
    WHERE job_id = 'ST_CLERK'
);
# 方式三:
SELECT department_id
FROM departments d
WHERE NOT EXISTS(
    SELECT 1
    FROM employees e
    WHERE job_id = 'ST_CLERK'
      AND d.department_id = e.department_id
);

#16. 选择所有没有管理者的员工的last_name
# 方式一:
SELECT last_name
FROM employees
WHERE manager_id IS NULL;

#方式二:
SELECT last_name
FROM employees emp
WHERE NOT EXISTS (
    SELECT 1
    FROM employees mgr
    WHERE emp.manager_id = mgr.employee_id
)

    #17．查询员工号、姓名、雇用时间、工资，其中员工的管理者为 'De Haan'
SELECT employee_id, last_name, hire_date, salary
FROM employees
WHERE manager_id = (
    SELECT employee_id FROM employees WHERE last_name = 'De Haan'
)

    #18.查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资（相关子查询）
SELECT employee_id, last_name, salary
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    GROUP BY department_id
    HAVING e1.department_id = e2.department_id
)

    #19.查询每个部门下的部门人数大于 5 的部门名称（相关子查询）
# 非相关查询
SELECT department_name, department_id
FROM departments dep
WHERE department_id IN(
    SELECT department_id
    FROM employees emp
    GROUP BY emp.department_id
    HAVING COUNT(department_id) > 5
);

# 相关查询
SELECT department_name, department_id
FROM departments dep
WHERE 5 < (
    SELECT COUNT(department_id)
    FROM employees emp
    WHERE dep.department_id = emp.department_id
);


#20.查询每个国家下的部门个数大于 2 的国家编号（相关子查询）
# 方式一:
SELECT COUNT(department_id) count_dep, country_id
FROM(
        SELECT d.department_id, l.country_id
        FROM departments d
                 RIGHT JOIN locations l
                            ON d.location_id = l.location_id
    ) dep_l
GROUP BY country_id
HAVING count_dep > 2

    # 方式二:
SELECT country_id
FROM locations l
WHERE 2 < (
    SELECT COUNT(*)
    FROM departments d
    WHERE l.location_id = d.location_id
)


/*
子查询的编写建议: 1.从里往外写; 2.从外往里写
如何选择:
	1. 如果子查询相对较简单,建议从外往里写; 一旦子查询结构较复杂,则建议从里往外写
	2. 如果是相关子查询的话,通常都是从外往里写;

*/