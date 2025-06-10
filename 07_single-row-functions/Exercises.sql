
# ======================== 07章节练习 ========================

#1.显示系统时间(注：日期+时间)
SELECT
    NOW(),
    SYSDATE(),
    CURRENT_TIMESTAMP ()
FROM
    DUAL;


#2.查询员工号，姓名，工资，以及工资提高百分之20%后的结果（newsalary）
SELECT
    employee_id,
    last_name,
    salary,
    salary * 1.2 AS 'newsalary'
FROM
    employees;


#3.将员工的姓名按首字母排序，并写出姓名的长度（length）
SELECT
    last_name,
    CHAR_LENGTH( last_name )
FROM
    employees
ORDER BY
    last_name;


#4.查询员工id,last_name,salary，并作为一个列输出，别名为OUT_PUT
SELECT
    CONCAT_WS( ' ', employee_id, last_name, salary ) AS 'OUT_PUT'
FROM
    employees;


#5.查询公司各员工工作的年数、工作的天数，并按工作年数的降序排序
# DATEDIFF( CURRENT_DATE (), hire_date ); TO_DAYS(NOW()) - TO_DAYS(hire_date);
SELECT
    last_name,
    DATEDIFF( CURRENT_DATE (), hire_date ) / 365 AS work_yerars,
    DATEDIFF( CURRENT_DATE (), hire_date ) AS work_days,
    TO_DAYS(NOW()) - TO_DAYS( hire_date ) 'work_days2'
FROM
    employees
ORDER BY
    work_yerars DESC;


#6.查询员工姓名，hire_date,department_id，满足以下条件：雇用时间在1997年之后，department_id 为80或90或110,commission_pct不为空
SELECT
    last_name,
    hire_date,
    department_id,
    commission_pct,
    EXTRACT( YEAR FROM hire_date )
FROM
    employees
        # WHERE hire_date >= '1997-01-01'		# 隐式转换
# WHERE hire_date >= STR_TO_DATE('1997-01-01', '%Y-%m-%d')	# 显示转换, 字符串转date, date类型之间做比较
    # WHERE DATE_FORMAT(hire_date,'%Y') >= '1997'		显示转换, 日期转为字符串, 字符串类型之间作比较
WHERE EXTRACT( YEAR FROM hire_date ) >= 1997
  AND department_id IN ( 80, 90, 110 )
  AND commission_pct IS NOT NULL;


#7.查询公司中入职超过10000天的员工姓名、入职时间
# WHERE字句中不能使用列的别名做条件; 这里使用子查询作为解决方案
SELECT
    *
FROM
    ( SELECT last_name, hire_date, DATEDIFF( CURRENT_DATE (), hire_date ) AS work_days FROM employees ) AS temp
WHERE
    work_days > 1000;


#8.做一个查询，产生下面的结果: <last_name>earns<salary>monthlybutwants<salary*3>
SELECT
    CONCAT_WS( ' ', last_name, 'earns', salary, 'monthly but wants', salary * 3 ) AS wantSalary
FROM
    employees;


# 9.使用case-when，按照下面的条件：
/*
job                grade
AD_PRES   					A
ST_MAN      				B
IT_PROG   					C
SA_REP   						D
ST_CLERK  					E
*/
SELECT
    last_name,
    job_id,
    CASE WHEN job_id = 'AD_PRES' THEN 'A'
         WHEN job_id = 'ST_MAN' THEN 'B'
         WHEN job_id = 'IT_PROG' THEN 'C'
         WHEN job_id = 'SA_REP' THEN 'D'
         WHEN job_id = 'ST_CLERK' THEN 'E'
         ELSE 'F'
        END AS 'grade'
FROM
    employees;

