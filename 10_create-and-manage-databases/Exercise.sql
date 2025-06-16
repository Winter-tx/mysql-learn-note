
# ======================== 07章节练习 ========================


# ======================== 07章节练习:练习1 ========================

#1. 创建数据库test01_office,指明字符集为utf8。并在此数据库下执行下述操作
CREATE DATABASE IF NOT EXISTS test01_office CHARACTER SET 'utf8';

USE test01_office;

#2. 创建表dept01
		/*
		字段 类型
		id INT(7)
		name VARCHAR(25)
		*/
CREATE TABLE IF NOT EXISTS dept01(
                                     id INT(7),
    `name` VARCHAR(25)
    );

#3. 将表departments中的数据插入新表dept02中
CREATE TABLE IF NOT EXISTS dept02
AS
SELECT * FROM atguigudb.departments;

#4. 创建表emp01
/*
字段 类型
id INT(7)
first_name VARCHAR (25)
last_name VARCHAR(25)
dept_id INT(7)
*/
CREATE TABLE IF NOT EXISTS emp01(
                                    id INT(7),
    first_name VARCHAR (25),
    last_name VARCHAR(25),
    dept_id INT(7)
    );

#5. 将列last_name的长度增加到50
ALTER TABLE emp01 MODIFY COLUMN last_name VARCHAR(50);

#6. 根据表employees创建emp02
CREATE TABLE IF NOT EXISTS emp02
AS
SELECT * FROM atguigudb.employees WHERE FALSE;

#7. 删除表emp01
DROP TABLE emp01;
DROP TABLE IF EXISTS emp01;

#8. 将表emp02重命名为emp01
RENAME TABLE emp02 TO emp01;
ALTER TABLE emp01 RENAME TO emp02;

#9. 在表dept02和emp01中添加新列test_column，并检查所作的操作
ALTER TABLE dept02 ADD test_column VARCHAR(10);
DESC dept02;

ALTER TABLE emp01 ADD  test_column VARCHAR(10);
DESC emp01;

#10.直接删除表emp01中的列 department_id
ALTER TABLE emp01 DROP COLUMN department_id



    # ======================== 07章节练习:练习2 ========================

# 1、创建数据库 test02_market
CREATE DATABASE IF NOT EXISTS test02_market;

USE test02_market;

# 2、创建数据表 customers
		/*
		字段			类型
		c_num			INT
		c_name		VARCHAR(50)
		c_contact	VARCHAR(50)
		c_city		VARCHAR(50)
		c_birth		DATE
		*/
CREATE TABLE IF NOT EXISTS customers(
                                        c_num			INT,
                                        c_name		VARCHAR(50),
    c_contact	VARCHAR(50),
    c_city		VARCHAR(50),
    c_birth		DATE
    );

SHOW TABLES;

DESC customers;

# 3、将 c_contact 字段移动到 c_birth 字段后面
ALTER TABLE customers MODIFY c_contact VARCHAR(50) AFTER c_birth;


# 4、将 c_name 字段数据类型改为 varchar(70)
ALTER TABLE customers MODIFY COLUMN c_Name varchar(70)

    # 5、将c_contact字段改名为c_phone
ALTER TABLE customers CHANGE COLUMN c_contact c_phone VARCHAR(50);

# 6、增加c_gender字段到c_name后面，数据类型为char(1)
ALTER TABLE customers ADD c_gender CHAR(1) AFTER c_name ;

# 7、将表名改为customers_info
RENAME TABLE customers TO customers_info;
ALTER TABLE customers_info RENAME TO customers;

# 8、删除字段c_city
ALTER TABLE customers_info DROP COLUMN c_city;


# ======================== 07章节练习:练习3 ========================

# 1、创建数据库test03_company
CREATE DATABASE IF NOT EXISTS test03_company;
USE test03_company;

# 2、创建表office
		/*
		字段				类型
		officeCode	INT
		city				VARCHAR(30)
		address			VARCHAR(50)
		country			VARCHAR(50)
		postalCode	VARCHAR(25)
		*/
CREATE TABLE IF NOT EXISTS office(
                                     officeCode	INT,
                                     city				VARCHAR(30),
    address			VARCHAR(50),
    country			VARCHAR(50),
    postalCode	VARCHAR(25)
    );

SHOW TABLES

# 3、创建表employee
		/*
		字段				类型
		empNum			INT
		lastName		VARCHAR(50)
		firstName		VARCHAR(50)
		mobile			VARCHAR(25)
		code				INT
		jobTitle		VARCHAR(50)
		birth				DATE
		note				VARCHAR(255)
		sex					VARCHAR(5)
		*/
CREATE TABLE IF NOT EXISTS employee(
                                       empNum			INT,
                                       lastName		VARCHAR(50),
    firstName		VARCHAR(50),
    mobile			VARCHAR(25),
    `code`			INT,
    jobTitle		VARCHAR(50),
    birth				DATE,
    note				VARCHAR(255),
    sex					VARCHAR(5)
    );

DESC employee;

# 4、将表employees的mobile字段修改到code字段后面
ALTER TABLE employee MODIFY COLUMN mobile VARCHAR(25) AFTER `code`;

# 5、将表employees的birth字段改名为birthday
ALTER TABLE employee CHANGE birth birthday DATE;

# 6、修改sex字段，数据类型为char(1)
ALTER TABLE employee MODIFY COLUMN sex VARCHAR(1);

# 7、删除字段note
ALTER TABLE employee DROP COLUMN note;

# 8、增加字段名favoriate_activity，数据类型为varchar(100)
ALTER TABLE employee ADD favoriate_activity varchar(100);

# 9、将表employees的名称修改为 employees_info
RENAME TABLE employee TO employees_info;
ALTER TABLE employees_info RENAME TO employee;
