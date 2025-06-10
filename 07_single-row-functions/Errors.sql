# SQL语句错误: -----------------------------------------------------------------------------------------------------
# 错误语句:
SELECT
	last_name,
	hire_date,
	DATEDIFF( CURRENT_DATE (), hire_date ) AS work_days
FROM
	employees
WHERE
	work_days > 1000;
# 错误提示: Unknown column 'work_days' in 'where clause'

# SQL错误解析：WHERE子句中不能使用SELECT语句中列别名; 在 SQL 执行顺序中, WHERE 子句在 SELECT 子句之前执行, 因此数据库引擎在评估 WHERE 条件时还不知道 work_days 这个别名.
/*
SQL 语句的执行顺序如下：
FROM/JOIN - 确定数据来源
WHERE - 筛选行数据
GROUP BY - 分组数据
HAVING - 筛选分组
SELECT - 选择列（包括计算列和别名）
ORDER BY - 排序结果
*/



# 方案一：重复计算表达式（简单直接）
SELECT
	last_name,
	hire_date,
	DATEDIFF( CURRENT_DATE (), hire_date ) AS work_days
FROM
	employees
WHERE
	DATEDIFF( CURRENT_DATE (), hire_date ) > 1000;

# 方案二：使用子查询（推荐，避免重复计算）
SELECT *
FROM (
    SELECT
        last_name,
        hire_date,
        DATEDIFF(CURRENT_DATE(), hire_date) AS work_days
    FROM employees
) AS emp_data
WHERE work_days > 1000;

# 方案三：使用HAVING子句（需关闭ONLY_FULL_GROUP_BY模式）
SELECT
    last_name,
    hire_date,
    DATEDIFF(CURRENT_DATE(), hire_date) AS work_days
FROM employees
HAVING work_days > 1000;
# 注意：HAVING 方案在某些SQL模式下可能不被允许（如MySQL的ONLY_FULL_GROUP_BY模式）



# SQL语句错误: -----------------------------------------------------------------------------------------------------
# 错误语句: