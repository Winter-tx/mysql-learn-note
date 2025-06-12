
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

/*
自连接与子查询:
	一般情况建议使用自连接，因为在许多 DBMS 的处理过程中，对于自连接的处理速度要比子查询快得多。
	可以这样理解：子查询实际上是通过未知表进行查询后的条件判断，而自连接是通过已知的自身数据表进行条件判断，
								因此在大部分 DBMS 中都对自连接处理进行了优化。
*/


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
/*
SQL中NULL表示“未知值”，任何与NULL的比较（如 = NULL、!= NULL）都会返回 UNKNOWN（既非TRUE也非FALSE）。当子查询返回的结果集中包含NULL时：
	1. IN子句：employee_id IN (1, 2, NULL) 若employee_id=1，则结果为TRUE（匹配成功）；
						 若employee_id=3，结果为UNKNOWN（不匹配），但仍可能返回其他匹配的行。
	2. NOT IN子句：等价于 NOT (employee_id = ANY (子查询结果)) 若子查询结果含NULL，
								 例如 (1, NULL)，则 employee_id NOT IN (1, NULL) 会被转换为： employee_id != 1 AND employee_id != NULL ;
								 由于 employee_id != NULL 的结果是UNKNOWN，而 UNKNOWN与任何逻辑操作组合后仍是UNKNOWN，导致整个条件失效，返回空结果集
*/
SELECT last_name
FROM employees
WHERE employee_id NOT IN (
    SELECT manager_id
    FROM employees
             # WHERE manager_id IS NOT NULL
);



# ======================== 09章节讲解: 04相关子查询 ========================

# 当内查询中, 出现了外查询的表了, 一般为相关查询(子查询的执行依赖于外部查询，通常情况下都是因为子查询中的表用到了外部的表，并进行了条件关联)
# 相关子查询的表现形式: 每执行一次外部查询，子查询都要重新计算一次，这样的子查询就称之为关联子查询。

# 练习: 查询员工中工资大于本部门平均工资的员工的last_name,salary和其department_id
# 方式一:
# 这里可以省略内查询中的 GROUP BY ; 因为 WHERE 条件已通过外查询的值动态限定了范围(即只有单个部门, 无需分组, 可以省略)
SELECT last_name, salary, department_id
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
    # GROUP BY department_id
    )

    # 方式二:
SELECT emp.last_name, emp.salary, emp.department_id
FROM employees emp
         INNER JOIN
     (
         SELECT department_id, AVG(salary) avg_salary
         FROM employees
         GROUP BY department_id
     ) dep_avg
     ON emp.department_id = dep_avg.department_id
         AND emp.salary > dep_avg.avg_salary

    # 查询员工的id,salary,按照department_name 排序
SELECT employee_id , salary
FROM employees e
ORDER BY (
             SELECT department_name
             FROM departments d
             WHERE e.department_id = d.department_id
         )

/*
结论: 在SELECT中, 除了ORDER BY和LIMIT之外, 其他位置都可以声明子查询

SELECT ..., ...., ...
FROM ... [LEFT/RIGHT]JOIN ... ON 多表的连接条件
WHERE 不包含聚合函数的过滤条件
GROUP BY ..., ...
HAVING 包含聚合函数的过滤条件
ORDER BY ... ASC/DESC
LIMIT ..., ...
*/

    # 练习: 若employees表中employee_id与job_history表中employee_id相同的数目不小于2，输出这些相同id的员工的employee_id,last_name和其job_id
# 方式一:
SELECT emp.employee_id, emp.last_name, emp.job_id
FROM employees emp
WHERE 2 <= (
    SELECT COUNT(*)
    FROM job_history jh
    WHERE emp.employee_id = jh.employee_id
)

    # 方式二:
SELECT emp.employee_id, emp.last_name, emp.job_id
FROM employees emp
         INNER JOIN (
    SELECT e.employee_id eid, COUNT(e.employee_id ) count_eid
    FROM employees e
             INNER JOIN job_history jh
                        ON e.employee_id = jh.employee_id
    GROUP BY e.employee_id
) ejh
                    ON emp.employee_id = ejh.eid
WHERE ejh.count_eid >= 2


    # EXISTS 与 NOT EXISTS关键字
/*
如果在子查询中不存在满足条件的行：条件返回 FALSE, 继续在子查询中查找
如果在子查询中存在满足条件的行：条件返回 TRUE, 不再继续查找

NOT EXISTS关键字表示如果不存在某种条件，则返回TRUE，否则返回FALSE。(与EXISTS相反)
*/
# 练习: 查询公司管理者的employee_id，last_name，job_id，department_id信息
# 方式一: 自关联
SELECT DISTINCT mgr.employee_id, mgr.last_name, mgr.job_id, mgr.department_id
FROM employees emp INNER JOIN employees mgr
                              ON emp.manager_id = mgr.employee_id

    # 方式二: 子查询
SELECT emp.employee_id, emp.last_name, emp.job_id, emp.department_id
FROM employees emp
WHERE emp.employee_id IN (
    SELECT DISTINCT manager_id FROM employees
)

    # 方式三: 使用EXISTS相关查询; 一般情况下 IN 与 EXISTS可以相互改写; 同样的 NOT IN 与 NOT EXISTS可以相互改写
SELECT mgr.employee_id, mgr.last_name, mgr.job_id, mgr.department_id
FROM employees mgr
WHERE EXISTS(
    SELECT 1
    FROM employees emp
    WHERE mgr.employee_id = emp.manager_id
)

/*
解释: 方式三中, 内查询使用 SELECT 1 是因为: 在 EXISTS 子查询中，数据库只关心子查询的行数据是否满足条件, 而完全不关心查询的列;

了解: 数据库优化：查询优化器会识别 EXISTS 子查询的语义;
			实际执行时通常不生成完整结果集，而是短路执行：扫描到第一条匹配记录即停止 → 立即返回 TRUE （因此选择哪些列对性能无影响）;
			EXISTS 性能取决于过滤条件速度

等价写法:
	1. SELECT 具体列名 ; (写出列名)
	2. SELECT 1 ; (任意常量, 甚至SELECT NULL, 明确表示, 只需要关注含数据是否满足条件 的意图)
	3. SELECT * ; (可能误导认为需要列数据, 类似于等价写法的第一种)

特殊: 唯一例外情况: 只有当子查询包含 GROUP BY 无 HAVING 时可能不同（极端边缘情况）：
	可能返回空分组 → EXISTS = FALSE
	SELECT 1 FROM employees GROUP BY department_id
	无 GROUP BY 时总是返回一行 → EXISTS = TRUE
	SELECT 1 FROM employees
*/


    # 练习: 查询departments表中，不存在于employees表中的部门的department_id和department_name
# 方式一: 部门表做主表, 左外连接
SELECT dep.department_id, dep.department_name
FROM departments dep
         LEFT JOIN employees emp ON dep.department_id = emp.department_id
WHERE emp.employee_id IS NULL;

# 方式二:
SELECT dep.department_id, dep.department_name
FROM departments dep
WHERE NOT EXISTS (
    SELECT 1
    FROM employees emp
    WHERE dep.department_id = emp.department_id
)



    # ======================== 09章节讲解: 04相关更新 ========================

# 在更新语句中, 内查询查询为相关查询, 先做了解, 后面讲到更新语句时会结合练习

# 相关更新示例
# 练习示例: 在employees中增加一个department_name字段，数据为员工对应的部门名称
# 增加department_name列, 新增加的列, 字段没有值(或者为默认值), 所以需要根据部门ID记性匹配更新
ALTER TABLE employees
    ADD(department_name VARCHAR2(14));
# 相关更新
UPDATE employees e
SET department_name = (
    SELECT department_name
    FROM   departments d
    WHERE  e.department_id = d.department_id
);

# 相关删除示例
# 练习示例: 删除表employees中，其与emp_history表皆有的数据
DELETE FROM employees emp
WHERE emp.employee_id IN(
    SELECT employee_id
    FROM emp_history eh
    WHERE emp.employee_id = eh.employee_id
)

