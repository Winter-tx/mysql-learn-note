
# ======================== 08章节:聚合函数 ========================

# 聚合函数不能嵌套调用



# ======================== 08章节讲解: 01常见聚合函数:AVG,SUM,MIN,MAX,COUNT ========================

/*
1. AVG(column), SUM(column), MIN(column), MAX(column), COUNT(column): 指定列时都会忽略NULL
		COUNT(*), COUNT(0), COUNT(1): 统计行数, 不会忽略NULL
*/


# 2. AVG,SUM: 仅适用于数值类型, 对于其他类型进行计算是没有意义的;
SELECT AVG(salary), SUM(salary) FROM employees;

# 计算结果没有意义, 仅适用于数值类型
SELECT AVG(last_name), SUM(last_name), SUM(hire_date) FROM employees;

# 3. MAX,MIN: 适用于数值类型, 字符串类型, 日期类型
SELECT MAX(salary), MIN(salary) FROM employees;

# 适用于数值类型, 字符串类型, 日期类型
SELECT MAX(last_name), MIN(last_name), MIN(hire_date) FROM employees;

# COUNT
# 作用: 计算指定字段在查询结果中出现的次数

# COUNT( employee_id ): employee_id在查询结果中出现的次数, 与id的数值没有关系
# COUNT( 1 ): 常量表达式, 统计所有行, 不针对特定列, 而是计算行数;(COUNT(0)结果相同)
                                                                 # COUNT(*): 统计所有行的数量, 包括所有列都是NULL的行(如果有这样的行), 因为它是计算表的行数, 而不是特定列
SELECT
    COUNT( employee_id ),
    COUNT( 1 ),
    COUNT(*)
FROM
    employees;

/*
计算表中有多少条数据的方式:
	1. COUNT(*)
	2. COUNT( 1 ): 常数
	3. COUNT( 列名 ): 通过列名计算时, 不计算空值; 不一定能够保证准确
*/

# 通过列名计算时, 不计算空值
SELECT  COUNT(commission_pct) FROM employees;

# AVG,SUM,MIN,MAX,COUNT: 都会忽略NULL
SELECT
    AVG( salary ),
    SUM( salary )/ COUNT( salary ),
    AVG( commission_pct ),
    SUM( commission_pct )/ COUNT( commission_pct ),
    SUM( commission_pct )/ 107
FROM
    employees;

# 练习: 查询公司的奖金率
SELECT
    SUM( commission_pct )/ COUNT( 1 ),
    # 为空时, 当做0参与运算
    AVG( IFNULL( commission_pct, 0 ))
FROM
    employees;

# 4. 如果需要统计表中的记录数, COUNT(*); COUNT( 1 ); COUNT( 列名 )三种方式中, 使用哪个效率更高?
/*
1. 如果是 MyISAM 存储引擎, 效率一样, 都是O(1); (mysql5.5之前的存储引擎)
2. 如果是 InnoDB 存储引擎, COUNT(*) = COUNT( 1 ) > COUNT( 列名 )
*/



# ======================== 08章节讲解: 02GROUP BY ========================
# 练习: 查询每个部门的平均工资
SELECT 	department_id, AVG( salary )
FROM employees
GROUP BY department_id;

# 练习: 查询每个department_id, job_id的平均工资
SELECT 	department_id, job_id, AVG( salary )
FROM employees
GROUP BY department_id, job_id;

# 1. 注意: SELECT 查询的字段, 必须声明在 GROUP BY 中; (如果根据department_id分组, 那么每个部门仅显示一行数据, 但是每个部门下job_id有多个, 所以查询job_id没有意义(会报错))
SELECT 	department_id, job_id, AVG( salary )
FROM employees
GROUP BY department_id;

# 2. 了解: GROUP BY中使用WITH ROLLUP: 在常规分组结果的基础上，按分组列的层次结构（从右向左逐级减少分组列）生成额外的汇总行
SELECT 	department_id, job_id, AVG( salary )
FROM employees
GROUP BY department_id, job_id WITH ROLLUP;

# 2.1. 注意: 当使用WITH ROLLUP时，不能同时使用ORDER BY子句进行结果排序，即ROLLUP和ORDER BY是互相排斥的
# 查询每个部门平均工资, 并根据平均工资升序排列
SELECT 	department_id, AVG( salary ) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY avg_salary;
# WITH ROLLUP不能与ORDER BY同时使用
SELECT 	department_id, AVG( salary ) AS avg_salary
FROM employees
GROUP BY department_id WITH ROLLUP
ORDER BY avg_salary;




# ======================== 08章节讲解: 03HAVING ========================
# 练习: 查询各个部门中, 最高工资比10000高的部门
# 错误写法:
SELECT
    department_id, MAX(salary)
FROM employees
WHERE  MAX(salary) > 10000
GROUP BY department_id;

# 正确写法:
# 注意1: 如果过滤条件中使用了聚合函数, 则必须使用HAVINIG来代替WHERE; 否则报错;
# 注意2: HAVINIG 必须声明在 GROUP BY 后面;
SELECT
    department_id, MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000;


/*
HAVING 必须依赖 GROUP BY（显式或隐式分组）
1. 隐式分组: SELECT MAX(salary) FROM employees HAVING MAX(salary) > 10000;
							SQL中没有使用 GROUP BY 仍然可以使用 HAVING, 是因为整个表被视为单一分组

2. 显示分组: SELECT  department_id, MAX(salary) FROM employees GROUP BY department_id HAVING MAX(salary) > 10000;

3. HAVING 只能引用分组字段或聚合函数: SELECT MAX(salary) FROM employees HAVING department_id = 10
																			报错提示: Unknown column 'department_id' in 'having clause'

*/

# 使用建议: 一般开发中使用 HAVINIG 的前提是 SQL 中使用了 GROUP BY, 如果没有 GROUP BY 仍然可以使用 HAVING, 但没有必要
# 比如: 删除 GROUP BY 之后, 是否使用 HAVING 查询都只有一条数据;
SELECT
    department_id, MAX(salary)
FROM employees
HAVING MAX(salary) > 10000;

# 练习: 查询部门10, 20, 30, 40这四个部门中最高工资比10000高的部门
# 方式1:
SELECT
    department_id, MAX(salary)
FROM employees
WHERE department_id IN (10, 20, 30, 40)
GROUP BY department_id
HAVING MAX(salary) > 10000;

# 方式2:
SELECT
    department_id, MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000
   AND department_id IN (10, 20, 30, 40);

/*
结论: 1. 当过滤条件中有聚合函数时, 则此过滤条件必须声明在HAVING中
			2. 当过滤条件中没有聚合函数时, 则此过滤条件声明在WHERE或者HAVING中都可以, 但使用WHERE效率更高;
					因为SELECT语句在执行时, WHERE会在GROUP BY前执行, 过滤了部分数据后, 后面处理会更快;

那么聚合函数为什么不能写在WHERE里? 聚合函数的前提是分组, 但是GROUP BY在WHERE之后执行, 所以WHERE时不能使用聚合函数
*/
/*
WHERE与HAVING对比
	1. 从适用范围上, HAVING范围更广(有聚合函数时,必须使用HAVING)
	2. 如果过滤条件没有聚合函数, WHERE的执行效率高于HAVING
*/



# ======================== 08章节讲解: 04SELECT的执行过程 ========================

# SELECT 语句的完整结构
               /*
               # SQL92
               SELECT ..., ...., ...
               FROM ..., ..., ...
               WHERE 多表的连接条件
               AND 不包含聚合函数的过滤条件
               GROUP BY ..., ...
               HAVING 包含聚合函数的过滤条件
               ORDER BY ... ASC/DESC
               LIMIT ..., ...
               */
/*
# SQL99
SELECT ..., ...., ...
FROM ... [LEFT/RIGHT]JOIN ... ON 多表的连接条件
WHERE 不包含聚合函数的过滤条件
GROUP BY ..., ...
HAVING 包含聚合函数的过滤条件
ORDER BY ... ASC/DESC
LIMIT ..., ...
*/


               # SELECT的执行过程
/*
FROM <left table>
ON <join_condition>
<join_type> [LEFT/RIGHT] JOIN <right_table>
WHERE <where condition>
GROUP BY <group_by_list>
HAVING <having_condition>
SELECT
DISTINCT <select list>
ORDER BY <order_by_condition>
LIMIT <limit number>
*/

/*
1. 聚合函数为什么不能必须声明在HAVING, 不能在WHERE?
		聚合函数的前提是分组, 但是GROUP BY在WHERE之后执行, 所以WHERE时不能使用聚合函数.
2. WHERE时为什么不能使用类的别名?
		同样的, WHERE在SELECT之前执行, WHERE时还没有别名.
3. 虽然HAVING在SELECT之前执行, 但可以使用别名; GROUP BY 在SELECT之前执行, 但也可以使用别名(MySQL语法糖)
		支持SELECT中别名: GROUP BY, HAVING, ORDER BY
		不支持SELECT中别名: WHERE (因在SELECT前执行,且无重写规则支持)
4. MySQL聚合计算复用: 在HAVING中使用聚合别名时,实际重写为聚合函数本身; 聚合计算不会重复执行, MySQL会复用计算结果
*/

# 示例: GROUP BY与HAVING可以使用SELECT中的别名
SELECT
    department_id AS depid, MAX(salary) AS max_salary
FROM employees
GROUP BY depid
HAVING max_salary > 10000
   AND depid IN (10, 20, 30, 40);


# 示例: AVING中使用聚合别名时,实际重写为聚合函数本身
SELECT MAX(salary) AS max_salary
FROM employees
HAVING max_salary > 10000;
# 重写后的等效语句:
SELECT MAX(salary) AS max_salary
FROM employees
HAVING MAX(salary) > 10000;

