
# ======================== 12章节:MySQL数据类型精讲 ========================


# ======================== 12章节讲解: 01MySQL中的数据类型 ========================

# CHARACTER SET name;
# 创建数据库时, 可以指定数据库字符集
CREATE DATABASE IF NOT EXISTS dbtest12 CHARACTER SET 'utf8';
SHOW CREATE DATABASE dbtest12;
USE dbtest12;

# 创建表时, 可以指定表的字符集
CREATE TABLE temp(
                     id INT
) CHARACTER SET 'utf8';
SHOW CREATE TABLE temp;

# 创建表时, 可以指定字段的字符集
CREATE TABLE temp1(
                      id INT,
                      `name` VARCHAR(15) CHARACTER SET 'gbk'
)
    SHOW CREATE TABLE temp1;

/*
创建表时, 如果字段没有显示声明字符集, 则按照创建表时显示声明的字符集;
创建表时, 如果表没有显示声明字符集, 则按照数据库显示声明的字符集;
创建数据库时, 如果没有显示声明字符集, 则按照数据库配置的字符集(my.ini)(SHOW VARIABLES LIKE 'character_%';)
*/



# ======================== 12章节讲解: 02整数类型 ========================

# 1. 数据的取值范围
USE dbtest12;
CREATE TABLE test_int1(
                          i1 TINYINT,
                          i2 SMALLINT,
                          i3 MEDIUMINT,
                          i4 INTEGER,
                          i5 BIGINT
);
DESC test_int1;

INSERT INTO test_int1 (i1)
VALUES
    (1),
    (-128),
    (127);

# 插入数据要在类型的数据范围内: Out of range value for column 'i1' at row 1;
INSERT INTO test_int1 (i1) VALUES (128);


# 2. 显示宽度, ZEROFILL, UNSIGNED
/*
INT(5): 括号内5表示显示宽度, 当未配置ZEROFILL时, 有无显示宽度不影响; 当配置ZEROFILL时, 不足显示宽度时会在数值前补0;
				而且, 当配置ZEROFILL时, 会同时默认设置UNSIGNED(无符号位)(补充0则表示只能为正数)
*/
# 显示宽度, ZEROFILL
CREATE TABLE test_int2(
                          f1 INT,
                          f2 INT(5),
                          f3 INT(5) ZEROFILL
);
DESC test_int2;

INSERT INTO test_int2(f1,f2)
VALUES(123,123), (123456,123456);

INSERT INTO test_int2(f1,f2,f3)
VALUES(123456,123456,123456);


# UNSIGNED
CREATE TABLE test_int3(
                          f1 INT UNSIGNED
);
DESC test_int3;

# 插入数据要在类型的数据范围内: Out of range value for column 'i1' at row 1;
INSERT INTO test_int3 (f1) VALUES (4294967296);



# ======================== 12章节讲解: 02浮点类型 ========================