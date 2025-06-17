
# ======================== 11章节练习 ========================



# ======================== 11章节练习:练习1 ========================

#1. 创建数据库dbtest11
CREATE DATABASE IF NOT EXISTS dbtest11 CHARACTER SET 'utf8';

USE dbtest11;


#2. 运行以下脚本创建表my_employees
CREATE TABLE my_employees(
                             id INT(10),
                             first_name VARCHAR(10),
                             last_name VARCHAR(10),
                             userid VARCHAR(10),
                             salary DOUBLE(10,2)
);

CREATE TABLE users(
                      id INT,
                      userid VARCHAR(10),
                      department_id INT
);


#3. 显示表my_employees的结构
DESC my_employees;


#4. 向my_employees表中插入下列数据
		/*
		ID	FIRST_NAME	LAST_NAME	USERID		SALARY
		1		patel				Ralph			Rpatel		895
		2		Dancs				Betty			Bdancs		860
		3		Bbiri				Ben				Bbiri			1100
		4		Newman			Chad			Cnewman		750
		5		Ropeburn		Audrey		Aropebur	1550
		*/
# 方式一：
INSERT INTO my_employees
(id, first_name, last_name, userid, salary)
VALUES
(1, 'patel', 'Ralph', 'Rpatel', 895),
(2, 'Dancs', 'Betty', 'Bdancs', 860),
(3, 'Bbiri', 'Ben', 'Bbiri', 1100),
(4, 'Newman', 'Chad', 'Cnewman', 750),
(5, 'Ropeburn', 'Audrey', 'Aropebur', 1550);

# DELETE FROM my_employees;

# 方式二：
INSERT INTO my_employees
SELECT 1,'patel','Ralph','Rpatel',895 UNION ALL
SELECT 2,'Dancs','Betty','Bdancs',860 UNION ALL
SELECT 3,'Biri','Ben','Bbiri',1100 UNION ALL
SELECT 4,'Newman','Chad','Cnewman',750 UNION ALL
SELECT 5,'Ropeburn','Audrey','Aropebur',1550


    #5. 向users表中插入数据
		/*
		1 Rpatel 10
		2 Bdancs 10
		3 Bbiri 20
		4 Cnewman 30
		5 Aropebur 40
		*/
    INSERT INTO users
(id, userid, department_id)
VALUES
    (1, 'Rpatel', 10),
    (2, 'Bdancs', 10),
    (3, 'Bbiri',  20),
    (4, 'Cnewman', 30),
    (5, 'Aropebur', 40);

#6. 将3号员工的last_name修改为“drelxer”
UPDATE my_employees SET last_name = 'drelxer'
WHERE id = 3;

#7. 将所有工资少于900的员工的工资修改为1000
UPDATE my_employees SET salary = 1000
WHERE salary < 900;

#8. 将userid为Bbiri的user表和my_employees表的记录全部删除
# 方式一:
DELETE FROM my_employees WHERE userid = 'Bbiri';
DELETE FROM users WHERE userid = 'Bbiri';

# 方式二:
DELETE u,e
FROM users u INNER JOIN my_employees e
ON u.`userid`=e.`Userid`
WHERE u.`userid`='Bbiri';


#9. 删除my_employees、users表所有数据
DELETE FROM my_employees;
DELETE FROM users;

#10. 检查所作的修正
SELECT * FROM my_employees;
SELECT * FROM users;

#11. 清空表my_employees
TRUNCATE TABLE my_employees;
TRUNCATE TABLE users;



# ======================== 11章节练习:练习2 ========================

# 1. 使用现有数据库dbtest11
USE dbtest11;

SHOW TABLES;

# 2. 创建表格pet

		/*
		字段名	字段说明	数据类型
		name		宠物名称	VARCHAR(20)
		owner		宠物主人	VARCHAR(20)
		species	种类			VARCHAR(20)
		sex			性别			CHAR(1)
		birth		出生日期	YEAR
		death		死亡日期	YEAR
		*/
CREATE TABLE IF NOT EXISTS pet(
                                  name		VARCHAR(20),
    owner		VARCHAR(20),
    species	VARCHAR(20),
    sex			CHAR(1),
    birth		YEAR,
    death		YEAR
    );


# 3. 添加记录
/*
name		owner		species	sex		birth	death
Fluffy	harold	Cat			f			2003	2010
Claws		gwen		Cat			m			2004
Buffy						Dog			f			2009
Fang		benny		Dog			m			2000
bowser	diane		Dog			m			2003	2009
Chirpy					Bird		f			2008
*/
INSERT INTO pet(`name`, `owner`, species, sex, birth, death)
VALUES
('Fluffy', 'harold', 'Cat', 'f', 2003, 2010),
('Claws', 'gwen', 'Cat', 'm', 2004, NULL),
('Buffy', NULL, 'Dog', 'f', 2009, NULL),
('Fang', 'benny', 'Dog', 'm', 2000, NULL),
('bowser', 'diane', 'Dog', 'm', 2003, 2009),
('Chirpy', NULL, 'Bird', 'f', 2008, NULL);

SELECT * FROM pet;
TRUNCATE TABLE pet;

# 4. 添加字段:主人的生日owner_birth DATE类型。
ALTER TABLE pet
    ADD owner_birth DATE;

DESC pet;


# 5. 将名称为Claws的猫的主人改为kevin
UPDATE pet
SET `owner` = 'kevin'
WHERE `name` = 'Claws'
  AND species = 'Cat';

SELECT * FROM pet;


# 6. 将没有死的狗的主人改为duck
UPDATE pet
SET `owner` = 'duck'
WHERE death IS NULL
  AND species = 'Dog';

# 7. 查询没有主人的宠物的名字；
SELECT `name`
FROM pet
WHERE `owner` IS NULL;


# 8. 查询已经死了的cat的姓名，主人，以及去世时间；
SELECT `name`, `owner`, death
FROM pet
WHERE death IS NOT NULL
  AND species = 'Cat';

# 9. 删除已经死亡的狗
DELETE FROM pet
WHERE death IS NOT NULL
  AND species = 'Dog';

# 10. 查询所有宠物信息
SELECT * FROM pet;



# ======================== 11章节练习:练习3 ========================

# 1. 使用已有的数据库dbtest11
USE dbtest11;

# 2. 创建表employee，并添加记录
/*
id		name		sex	tel						addr			salary
10001	张一一	男	13456789000		山东青岛	1001.58
10002	刘小红	女	13454319000		河北保定	1201.21
10003	李四		男	0751-1234567	广东佛山	1004.11
10004	刘小强	男	0755-5555555	广东深圳	1501.23
10005	王艳		女	020-1232133		广东广州	1405.16
*/
CREATE TABLE IF NOT EXISTS employee(
                                       id CHAR(8),
    name VARCHAR(16),
    sex	CHAR(4),
    tel VARCHAR(32),
    addr VARCHAR(32),
    salary DOUBLE(8,2)
    );

INSERT INTO employee(id, `name`, sex, tel, addr, salary)
VALUES
    ('10001', '张一一', '男', '13456789000', '山东青岛', 1001.58),
    ('10002', '刘小红', '女', '13454319000', '河北保定', 1201.21),
    ('10003', '李四', '男', '0751-1234567', '广东佛山', 1004.11),
    ('10004', '刘小强', '男', '0755-5555555', '广东深圳', 1501.23),
    ('10005', '王艳', '女', '020-1232133', '广东广州', 1405.16);

# 3. 查询出薪资在1200~1300之间的员工信息。
# 方式一:
SELECT *
FROM employee
WHERE salary >= 1200
  AND salary <= 1300;

# 方式二:
SELECT *
FROM employee
WHERE salary BETWEEN 1200 AND 1300;


# 4. 查询出姓“刘”的员工的工号，姓名，家庭住址。
SELECT id, `name`, addr
FROM employee
WHERE `name` LIKE '刘%';

# 5. 将“李四”的家庭住址改为“广东韶关”
UPDATE employee
SET addr = '广东韶关'
WHERE `name` = '李四';

# 6. 查询出名字中带“小”的员工
SELECT *
FROM employee
WHERE `name` LIKE '%小%';