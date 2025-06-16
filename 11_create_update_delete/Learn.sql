
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
