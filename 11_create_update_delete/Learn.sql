
# ======================== 11章节:数据处理之增删改(DML) ========================

/*
小结:
1. DML默认情况下, 执行完之后会自动提交数据; 如果希望不自动提交, 则需要使用 SET autocommit = FALSE;
*/


# 准备工作
USE atguigudb;

CREATE TABLE IF NOT EXISTS emp1(
                                   id INT,
                                   `name` VARCHAR(15),
    hire_date DATE,
    salary DOUBLE(10,2)
    );

DESC emp1;


# ======================== 11章节讲解: 01插入数据 ========================

# 1. 单条添加

# 未显示指明添加的字段, 则一定需要按照创建表声明时的字段顺序添加值;
INSERT INTO emp1 VALUES (1, 'Tom', '2000-01-10', 2000);

# 显示指明添加的字段, 则按照显示声明的顺序添加值; 可不添加所有字段, 为添加值的字段, 为表字段设置的默认值(NULL,或空字符串,或0,等等)
INSERT INTO emp1 (id, salary, `name` ) VALUES (2, 3000, 'Jerry');

# 同时添加多条数据
# 这种多行的INSERT语句, 相对于多个单行的INSERT语句, 效率更高;
INSERT INTO emp1(id, `name`, hire_date, salary)
VALUES
    (3, '张三','2024-02-23',3900),
    (4, '李四','2024-05-18',4200);


# 2. 将查询结果插入到表中

# 查询的字段与要插入数据的表的字段一一对应(类型对应,插入表的数据范围一般大于等于查询表)
INSERT INTO emp1(id, `name`, hire_date, salary)
SELECT employee_id, last_name, hire_date, salary
FROM employees
WHERE department_id IN (60,70);



# ======================== 11章节讲解: 02更新数据 ========================

/*
语法:
	UPDATE ... SET ... WHERE ...;

	UPDATE 表名
	SET 字段1 = 值1,
			字段2 = 值2
	WHERE ...
*/

# 建议加上WHERE, 否则会修改全部数据;
UPDATE emp1
SET hire_date = CURDATE(),
    salary  = 5000
WHERE id = 2;

# 练习: 将姓名中包含字符a的, 提薪20%
UPDATE emp1
SET salary = salary * 120
WHERE `name` LIKE '%a%'


    # 修改数据时可能失败(可能是因为约束的原因)
# 部门ID有外键约束, 部门表没有10000的数据, 所以失败;同样的新增也可能失败;
UPDATE employees
SET department_id = 10000
WHERE	employee_id = 102;



# ======================== 11章节讲解: 03删除数据 ========================

/*
语法: DELETE FROM 表名 WHERE ...;
*/
# 建议加上WHERE, 否则会删除全部数据;
DELETE FROM emp1
WHERE id = 1;

# 删除数据时可能失败(可能是因为约束的原因)
# 50号部门有员工, 不允许删除
DELETE FROM departments WHERE department_id = 50;



# ======================== 11章节讲解: 04MySQL8新特性:计算列 ========================

CREATE TABLE tb1(
                    id INT,
                    a INT,
                    b INT,
                    c INT GENERATED ALWAYS AS (a + b) VIRTUAL
);

# 对a和b插入值, c被计算后赋值
INSERT INTO tb1(id, a, b) VALUES (1, 10, 20);
SELECT * FROM tb1;

# 对a与b进行更新后, c也会同步更新
UPDATE tb1 SET a = 100 WHERE id = 1;
SELECT * FROM tb1;

# 不能修改计算列: The value specified for generated column'c'in table 'tb1'is not allowed
UPDATE tb1 SET c = 100 WHERE id = 1;



# ======================== 11章节讲解: 05综合案例 ========================

# 1、创建数据库test01_library
CREATE DATABASE IF NOT EXISTS test01_library;

USE test01_library;


# 2、创建表 books，表结构如下：
		/*
		字段名		字段说明		数据类型
		id				书编号			INT
		name			书名				VARCHAR(50)
		authors		作者				VARCHAR(100)
		price			价格				FLOAT
		pubdate		出版日期		YEAR
		note			说明				VARCHAR(100)
		num				库存				INT
		*/
CREATE TABLE IF NOT EXISTS books(
                                    id				INT,
                                    name			VARCHAR(50),
    authors		VARCHAR(100),
    price			FLOAT,
    pubdate		YEAR,
    note			VARCHAR(100),
    num				INT
    );

SHOW TABLES;

DESC books;


# 3、向books表中插入记录
SELECT * FROM books;

# 1）不指定字段名称，插入第一条记录
INSERT INTO books VALUES (1, 'Tal of AAA', 'Dickes', 23, '1995', 'novel', 11);

# 2）指定所有字段名称，插入第二记录
INSERT INTO books (id, `name`, `authors`, price, pubdate, note, num)
VALUES
(2, 'EmmaT', 'Jane lura', 35, '1993', 'joke', 22);


# 3）同时插入多条记录（剩下的所有记录）
		/*
		id		name					authors					price	dubdate		note		num
		1			Tal of AAA		Dickes					23		1995			novel		11
		2			EmmaT					Jane lura				35		1993			joke		22
		3			Story of Jane	Jane Tim				40		2001			novel		0
		4			Lovey Day			George Byron		20		2005			novel		30
		5			Old land			Honore Blade		30		2010			law			0
		6			The Battle		Upton Sara			30		1999			medicine40
		7			Rose Hood			Richard haggard	28		2008			cartoon	28
		*/
INSERT INTO books (id, `name`, `authors`, price, pubdate, note, num)
VALUES
(3, 'Story of Jane', 'Jane Tim', 40, '2001', 'novel', 0),
(4, 'Lovey Day', 'George Byron', 20, '2005', 'novel', 30),
(5, 'Old land', 'Honore Blade', 30, '2010', 'law', 0),
(6, 'The Battle', 'Upton Sara', 30, '1999', 'medicine', 40),
(7, 'Rose Hood', 'Richard haggard', 28, '2008', 'cartoon', 28);


# 4、将小说类型(novel)的书的价格都增加5。
UPDATE books
SET price = price + 5
WHERE note = 'novel';

SELECT * FROM books;


# 5、将名称为EmmaT的书的价格改为40，并将说明改为drama。
UPDATE books
SET price = 40,
    note = 'drama'
WHERE `name` = 'EmmaT';


# 6、删除库存为0的记录。
DELETE FROM books WHERE num = 0;

# 7、统计书名中包含a字母的书
SELECT `name`
FROM books
WHERE `name` LIKE '%a%';

# 8、统计书名中包含a字母的书的数量和库存总量
SELECT COUNT(1), SUM(num)
FROM books
WHERE `name` LIKE '%a%';

# 9、找出“novel”类型的书，按照价格降序排列
SELECT *
FROM books
WHERE note = 'novel'
ORDER BY price DESC;

# 10、查询图书信息，按照库存量降序排列，如果库存量相同的按照note升序排列
SELECT *
FROM books
ORDER BY num DESC,
         note ASC;

# 11、按照note分类统计书的数量
SELECT note, COUNT(1)
FROM books
GROUP BY note;

# 12、按照note分类统计书的库存量，显示库存量超过30本的
SELECT note, SUM(num) AS sum_num
FROM books
GROUP BY note
HAVING sum_num > 30;

# 13、查询所有图书，每页显示5本，显示第二页
SELECT *
FROM books
         # LIMIT 5, 5;
LIMIT 5 OFFSET 5;


# 14、按照note分类统计书的库存量，显示库存量最多的
# 方式一:
SELECT MAX(sum_num)
FROM (
         SELECT note, SUM(num) sum_num
         FROM books
         GROUP BY note
     ) t_note_sum;
# 方式二:
SELECT note, SUM(num) sum_num
FROM books
GROUP BY note
HAVING sum_num >= ALL(
    SELECT SUM(num)
    FROM books
    GROUP BY note
);
# 方式三:
SELECT note, SUM(num) sum_num
FROM books
GROUP BY note
ORDER BY sum_num DESC
    LIMIT 0, 1;


# 15、查询书名达到10个字符的书，不包括里面的空格
# 使用REPLACE()去除空格: REPLACE(`name`,' ', '')
SELECT `name`,
       CHAR_LENGTH()
FROM books;

# 16、查询书名和类型，其中note值为novel显示小说，law显示法律，medicine显示医药，cartoon显示卡通，joke显示笑话
SELECT
    `name`, note,
    CASE note
        WHEN 'novel' THEN '小说'
        WHEN 'law' THEN '法律'
        WHEN 'medicine' THEN '医药'
        WHEN 'cartoon' THEN '卡通'
        WHEN 'joke' THEN '笑话'
        END note
FROM books;

# 17、查询书名、库存，其中num值超过30本的，显示滞销，大于0并低于10的，显示畅销，为0的显示需要无货
SELECT
    `name`, num,
    CASE
        WHEN num > 30 THEN '滞销'
        WHEN 10 > num AND num > 0 THEN '畅销'
        WHEN num = 0 THEN '无货'
        ELSE '正常'
        END num_alias
FROM books;

# 18、统计每一种note的库存量，并合计总量-----(不会:如何合计总量: WITH ROLLUP)
SELECT note, SUM(num)
FROM books
GROUP BY note WITH ROLLUP;


# 19、统计每一种note的数量，并合计总量-----(不会:如何合计总量: WITH ROLLUP)
SELECT IFNULL(note, '合计总量') AS note, COUNT(1)
FROM books
GROUP BY note  WITH ROLLUP;


# 20、统计库存量前三名的图书
SELECT *
FROM books
ORDER BY num DESC
    LIMIT 0, 3;

# 21、找出最早出版的一本书
SELECT MAX(pubdate)
FROM books

         # 22、找出novel中价格最高的一本书
# 方式一:
SELECT note, MAX(price)
FROM books
WHERE note = 'novel';

# 方式二:
SELECT *
FROM books
ORDER BY price DESC
    LIMIT 0, 1;

# 23、找出书名中字数最多的一本书，不含空格
# 方式一:
SELECT
    MAX(CHAR_LENGTH(REPLACE(`name`,' ', '')) )
FROM books;

# 方式二:
SELECT * ,CHAR_LENGTH(REPLACE(`name`,' ', '')) name_len
FROM books
ORDER BY name_len ASC
    LIMIT 0, 1;
