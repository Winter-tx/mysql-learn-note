
# ======================== 09章节:子查询 ========================



# ======================== 09章节讲解: 01子查询的引入 ========================

# 练习: 谁的工资比Abel的高
# 方式一: 先查Abel工资, 再查工资高于Abel的人员信息
# 两次SQL执行, 如果是web服务器与数据库服务器之间通信, 则需要两次
SELECT salary FROM employees WHERE last_name = 'Abel';
SELECT last_name, salary FROM employees WHERE salary > 11000;

# 方式二: 自关联
# 复习: 多表连接三种情况: 连接条件等值连接与非等值连接; 自连接与非自连接; 内连接与外连接
SELECT
    e2.last_name,	e2.salary
FROM
    employees e1 LEFT JOIN employees e2
    # 多表连接条件: 非等值连接的情况
ON e1.salary < e2.salary
WHERE
    e1.last_name = 'Abel';

# 方式三: 子查询
SELECT last_name, salary
FROM employees
WHERE salary > (
    SELECT salary FROM employees WHERE last_name = 'Abel'
);


#
/*
称谓的规范: 外查询与内查询; 主查询与子查询

子查询（内查询）在主查询之前一次执行完成。

子查询的结果被主查询（外查询）使用 。

注意事项
	子查询要包含在括号内
	将子查询放在比较条件的右侧
	单行操作符对应单行子查询，多行操作符对应多行子查询
*/
/*
子查询的分类:
角度一: 从内查询返回的结果行数
				单行子查询: 内查询只返回一条记录
				多行子查询: 内查询返回多条记录

角度二: 内查询是否被执行多次
				相关子查询: 内查询执行多次
				不相关子查询: 内查询执行一次

角度二示例:
相关子查询需求示例: 查询工资大于本部门平均工资的员工信息: 子查询为查询本部门的工资, 当外查询中前一条张三在A部门记录与后一条记录李四在B部门为不同部门时
										, 内查询也要切换部门, 与查询具有相关性的执行多次;
不相关子查询需求示例: 查询工资大于本公司平均工资的员工信息: 内查询为获取本公司平均工资, 外查询的每一条记录都是与本公司平均工资比较,
												内查询只执行一次即可, 不需要根据外查询的数据切换而相关性的多次执行;
*/



# ======================== 09章节讲解: 02单行子查询 ========================

# 单行比较操作符: =  >  >=  <  <=  <>

# 练习: 查询工资大于149号员工工资的员工的信息
SELECT last_name, salary
FROM employees
WHERE salary > (
    SELECT salary FROM employees WHERE employee_id = 149
)

    # 练习: 返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id和工资
SELECT last_name, job_id, salary
FROM employees
WHERE job_id = (
    SELECT job_id FROM employees WHERE employee_id = 144
)
  AND salary > (
    SELECT salary FROM employees WHERE employee_id = 143
);

# 练习: 返回公司工资最少的员工的last_name,job_id和salar
SELECT last_name, job_id, salary
FROM employees
WHERE salary = (
    SELECT MIN(salary) FROM employees
);

# 练习: 查询与141号员工的manager_id和department_id相同的其他员工的employee_id，manager_id，department_id
# 方式一:
SELECT employee_id, manager_id, department_id
FROM employees
WHERE manager_id = (
    SELECT manager_id FROM employees WHERE employee_id = 141
)
  AND department_id = (
    SELECT department_id FROM employees WHERE employee_id = 141
)
  AND employee_id <>141;

# 方式二 (了解):
# WHERE条件使用括号括起来, 与内查询中的顺序保持一致
SELECT employee_id, manager_id, department_id
FROM employees
WHERE (manager_id, department_id) = (
    SELECT manager_id, department_id
    FROM employees
    WHERE employee_id = 141
)
  AND employee_id <>141;

# 练习(HAVING中的子查询): 查询最低工资大于50号部门最低工资的部门id和其最低工资
SELECT department_id, MIN(salary) AS 'min_salary'
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING min_salary > (
    SELECT MIN(salary) FROM employees WHERE department_id = 50
)

    # 练习(CASE中的子查询): 显式员工的employee_id,last_name和location。其中，若员工department_id与location_id为1800的department_id相同，则location为’Canada’，其余则为’USA’。
SELECT
    employee_id,
    last_name,
    CASE
        department_id
        WHEN ( SELECT department_id FROM departments WHERE location_id = 1800 ) THEN 'Canada'
        ELSE 'USA'
        END AS 'location'
FROM
    employees

        # 单行子查询中的空值问题
# 内查询结果没有数据
SELECT last_name,	job_id
FROM employees
WHERE	job_id = (
    SELECT job_id FROM  employees WHERE  last_name = 'Haas'
);

# 非法使用子查询
# 单行子查询中, 内查询的结果超过一行
SELECT employee_id, last_name
FROM employees
WHERE salary = (
    SELECT MIN(salary) FROM employees GROUP BY department_id
);



# ======================== 09章节讲解: 03多行子查询 ========================

/*
多行比较操作符:
	IN: 等于列表中的 任意一个
	ANY: 需要和单行比较操作符一起使用，和子查询返回的 某一个值 比较; (某一个值, 任一, 有一个满足就行)
	ALL: 需要和单行比较操作符一起使用，和子查询返回的 所有值 比较; (所有值, 任意, 每一个都要满足)
	SOME: 实际上是ANY的别名，作用相同，一般常使用ANY
*/

# 练习: 查出每个部门的最低工资, 获取工资与这些最低工资相等的员工的信息(注意: 并不是获取每个部门工资最低的员工信息)
SELECT employee_id, last_name
FROM employees
WHERE salary IN (
    SELECT MIN(salary) FROM employees GROUP BY department_id
);

# 练习拓展: 获取每个部门中工资最低的员工的信息
# 练习拓展-方式一:
SELECT emp.employee_id, emp.last_name, emp.salary, emp.department_id
FROM employees emp
         INNER JOIN (
    SELECT department_id, MIN(salary) min_salary FROM employees GROUP BY department_id
) min_dep
                    ON emp.department_id = min_dep.department_id
                        AND emp.salary = min_dep.min_salary

    # 练习拓展-方式二:
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE (department_id, salary) IN (
    SELECT department_id, MIN(salary) FROM employees GROUP BY department_id
)

    # 练习拓展-方式三:
SELECT employee_id, last_name, salary, department_id
FROM employees e1
WHERE salary = (
    SELECT MIN(salary) FROM employees e2 WHERE e2.department_id = e1.department_id
)

    # 练习拓展-方式四: 使用窗口函数
# PARTITION BY department_id: 将数据按department_id分割为独立的分区, 每个部门单独计算排名
# ORDER BY salary: 根据salary排序
    # DENSE_RANK() OVER (): DENSE_RANK(): 排名函数, 相同排名排序值相同, 且后续连续, 如: 1,1,2,3
SELECT employee_id, last_name, salary, department_id
FROM (
         SELECT employee_id, last_name, salary, department_id,
                DENSE_RANK() OVER (
													PARTITION BY department_id
													ORDER BY salary
													) AS salary_rank
         FROM employees
     ) ranked
WHERE salary_rank = 1;

# 练习: 返回其它job_id中比job_id为‘IT_PROG’的 任一 工资低的员工的员工号、姓名、job_id 以及salar
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary < ANY (
    SELECT salary FROM employees WHERE job_id = 'IT_PROG'
)
  AND job_id != 'IT_PROG'

# 练习: 返回其它job_id中比job_id为‘IT_PROG’的 所有 工资低的员工的员工号、姓名、job_id 以及salar
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary < ALL (
    SELECT salary FROM employees WHERE job_id = 'IT_PROG'
)
  AND job_id != 'IT_PROG'

# 练习: 查询平均工资最低的部门id
# 方式一:
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
HAVING AVG(salary) = (
    SELECT MIN(avg_salary)
    FROM(
            SELECT department_id, AVG(salary) AS avg_salary
            FROM employees
            WHERE department_id IS NOT NULL
            GROUP BY department_id
        ) dep_avg
);

# 方式二:
SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) <= ALL (
    SELECT AVG(salary) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)

    # 方式三:
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY avg_salary ASC
    LIMIT 0,1

# 多行子查询中的空值问题
# 当内查询有null值时, 返回的结果为空
SELECT last_name
FROM employees
WHERE employee_id NOT IN (
    SELECT manager_id
    FROM employees
             # WHERE manager_id IS NOT NULL
);



# ======================== 09章节讲解: 04相关子查询 ========================


