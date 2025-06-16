
# ======================== 10章节:创建和管理表 ========================



# ======================== 10章节讲解: 01创建和管理数据库 ========================

# 1.1 创建数据库
# 方式一: CREATE DATABASE 数据库名;
CREATE DATABASE create_test_01;

# 查看当前所有的数据库
SHOW DATABASES

/*
方式二: CREATE DATABASE 数据库名 CHARACTER SET 字符集;
创建并指定字符集;
如果没有显示指定字符集, 就会使用数据库默认配置的字符集(通过 SHOW VARIABLES LIKE 'character_%' 可以查看)
*/
CREATE DATABASE create_test_02 CHARACTER SET 'gbk';

# 查询数据库创建的具体语句
SHOW CREATE DATABASE create_test_01;

/*
方式三: CREATE DATABASE IF NOT EXISTS 数据库名;

如果不存在同名数据库, 则创建成功;
如果存在, 则创建失败, 但不会报错;
*/
CREATE DATABASE IF NOT EXISTS create_test_02 CHARACTER SET 'utf8mb4';


# 1.2 管理数据库
# 查看当前连接中的数据库
SHOW DATABASES;

# 切换要操作的数据库: USE 数据库名
USE create_test_02;

# 查看当前正在操作的数据库
SELECT DATABASE();

# 查看正在操作的数据库下所有的表
SHOW TABLES;

# 查看指定数据库下所有的表: SHOW TABLES FROM 数据库名;
SHOW TABLES FROM create_test_02;


# 1.3 修改数据库
# DATABASE 不能改名。一些可视化工具可以改名，它是建新库，把所有表复制到新库，再删旧库完成的。
# 修改数据库字符集: ALTER DATABASE 数据库名 CHARACTER SET 字符集;
SHOW CREATE DATABASE create_test_02;
ALTER DATABASE create_test_02 CHARACTER SET 'utf8mb4';


# 1.4 删除数据库
# 方式一: DROP DATABASE 数据库名;
DROP DATABASE create_test_01;

/*
方式二: DROP DATABASE IF EXISTS 数据库名;
如果数据库存在, 则删除成功;
如果不存在, 则删除失败, 但不会报错;
*/
DROP DATABASE IF EXISTS create_test_02;




# ======================== 10章节讲解: 02创建表 ========================

/*
方式一:
CREATE TABLE [IF NOT EXISTS] 表名(
字段1, 数据类型 [约束条件] [默认值],
字段2, 数据类型 [约束条件] [默认值],
......
[表约束条件]
);
需要用户有创建表的权限
*/
USE atguigudb;

CREATE TABLE IF NOT EXISTS myemp(
                                    id INT,
                                    emp_name VARCHAR(15),
    hire_date DATE
    );

# 查看表结构: DESC 表名
DESC my_emp;

# 查看创建表的具体语句(与数据库操作类似)
# 如果创建表时没有指定使用的字符集, 则默认使用表所在数据库的字符集; 如果数据库也没有指定字符集, 则根据数据库的配置确定(通过 SHOW VARIABLES LIKE 'character_%' 可以查看)
SHOW CREATE TABLE my_emp;

/*
方式二: 基于现有的表创建

AS subquery: 基于子查询, 将创建表和插入数据结合一起
*/
CREATE TABLE myemp2
AS
SELECT employee_id, last_name, salary
FROM employees;

# 查看表结构
DESC myemp2;
DESC employees;

SELECT * FROM myemp2;

# 方式二示例2:
# 新创建的表的列名与查询的列名保持一致(新表的字段名为查询中的别名)
CREATE TABLE myemp3
AS
SELECT employee_id empid, last_name lname, salary, emp.department_id depid, department_name depname
FROM employees emp
         INNER JOIN departments dep
                    ON emp.department_id = dep.department_id;

SELECT * FROM myemp3;

#练习: 创建一个表employee_copy, 实现对employees表的复制, 包括表数据
CREATE TABLE employee_copy
AS
SELECT * FROM employees;

SELECT * FROM employee_copy;

#练习: 创建一个表employee_blank, 实现对employees表的复制, 不包括表数据(通过条件过滤数据即可)
CREATE TABLE employee_blank3
AS
SELECT * FROM employees
                  # WHERE employee_id < 1;
# WHERE FALSE
LIMIT 0, 0



# ======================== 10章节讲解: 03管理表 ========================

# 3.1 修改表: ALTER TABLE 表名

    DESC myemp;

# 添加一个字段: ALTER TABLE 表名 ADD 字段名 数据类型 [约束条件] [默认值]

# 默认添加到表的最后一个字段位置
ALTER TABLE myemp
    ADD salary DOUBLE(10,2);

/*
FIRST: 添加到表的第一个字段位置
AFTER 字段名: 添加到指定字段后面的位置
*/
ALTER TABLE myemp
    ADD phone VARCHAR(20) FIRST;

ALTER TABLE myemp
    ADD alias_name VARCHAR(20) AFTER emp_name;

# 修改一个字段(数据类型, 长度, 默认值, 约束, ...): ALTER TABLE 表名 MODIFY [COLUMN] 字段名 数据类型 [约束条件] [默认值]
ALTER TABLE myemp MODIFY COLUMN emp_name VARCHAR(32) DEFAULT '';

# 重命名一个字段: ALTER TABLE 表名 CHANGE  [COLUMN] 字段名 新字段名 数据类型 [约束条件] [默认值]
    # 语句中需带有数据类型, 且会一起更改
ALTER TABLE myemp CHANGE COLUMN salary monthly_salary double(12,2);

# 删除一个字段: ALTER TABLE 表名 DROP [COLUMN] 字段名
ALTER TABLE myemp DROP COLUMN alias_name

    # 3.2 重命名表: RENAME TABLE... / ALTER TABLE...

    # 方式一: RENAME TABLE 表名 TO 新表名;
RENAME TABLE myemp2 TO re_myremp2;

# 方式一: ALTER TABLE 表名 RENAME [TO] 新表名;
ALTER TABLE myemp3 RENAME TO re_myremp3;


# 3.3 删除表: DROP TABLE [IF EXISTS] 表名 [, 表名2, 表名3, ...];
/*
DROP TABLE 语句不能回滚;
删除 表结构 以及 表中的数据,  释放表空间;
*/
DROP TABLE IF EXISTS re_myremp2, re_myremp3;


# 3.4 清空表: TRUNCATE TABLE 表名;
/*
TRUNCATE语句不能回滚，而使用 DELETE 语句删除数据可以回滚;
清空表中的数据, 表结构保留;
*/
TRUNCATE TABLE employee_copy;


/*
DCL中COMMIT和ROLLBACK:
	COMMIT: 提交数据; 一旦执行COMMIT, 则数据被永久保存在数据库中, 不可以回滚.
	ROLLBACK: 回滚数据; 一旦执行, 可以实现数据的回滚, 回滚到最近的一次COMMIT.
*/

/*
对比 TRUNCATE TABLE 和 DELETE FROM:
相同点: 都可以实现对表中数据的删除, 同时保留表结构;
不同点:
			TRUNCATE TABLE: 表数据全部清除; 数据是不可以回滚的
			DELETE FROM: 表数据可以全部清除(WHERE条件); 数据可以实现回滚
*/


/*
DDL 和 DML:
1. DDL操作一旦执行, 就不可以回滚
		在执行完DDL之后, 一定会执行一次COMMIT, 而此操作不受'SET autocommit = FALSE'影响
		例如: TRUNCATE TABLE;
2. DML操作一旦执行, 默认情况下不可以回滚; 但是在执行DML之前只执行了'SET autocommit = FALSE', 则执行的DML操作可以回滚;
		例如: DELETE FROM;
*/
# 演示DELETE FROM:
# 先提交一次, 避免影响后续操作
COMMIT ;

# 查询一下初始数据;
SELECT * FROM myemp3;

# 关闭DML自动提交
SET autocommit = FALSE;
# 删除数据
DELETE FROM myemp3;

# 回滚 DELETE FROM 数据删除操作
    ROLLBACK;


# 演示TRUNCATE TABLE:
# 先提交一次, 避免影响后续操作
COMMIT ;

# 查询一下初始数据;
SELECT * FROM myemp3;

# 删除数据
TRUNCATE TABLE myemp3;

# 回滚 DELETE FROM 数据删除操作
    ROLLBACK;


# 测试MySQL8新特性—DDL的原子化
CREATE DATABASE mytest;

USE mytest;

CREATE TABLE book1(
                      book_id INT ,
                      book_name VARCHAR(255)
);

SHOW TABLES;

# 只有book1, 删除时删除book1和book2
# 在MySQL5.7或8.0中执行都会报错, 但5.7会将book1删除; 8.0不会删除book1;
DROP TABLE book1,book2;

