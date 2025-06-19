
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



# ======================== 12章节讲解: 03浮点类型 ========================

CREATE DATABASE dbtest12;
USE dbtest12;

CREATE TABLE test_double1(
                             f1 FLOAT,
                             f2 FLOAT(5,2),
f3 DOUBLE,
f4 DOUBLE(5,2)
);
DESC test_double1;

# 对于f2, f4设置了精度与标度时, 存在四舍五入
INSERT INTO test_double1 VALUES(123.456, 123.456, 123.4567, 123.4567);

# 当整数位的位数过多时会报错: Out of range value for column 'f2' at row 1
INSERT INTO test_double1 VALUES(1234.456);
INSERT INTO test_double1 VALUES(999.995);

SELECT * FROM test_double1;

# 测试FLOAT与DOUBLE 的精度:
CREATE TABLE test_double2(
                             f1 DOUBLE
);
INSERT INTO test_double2 VALUES(0.47),(0.44),(0.19);
# 1.09999...; 应该为1.1, 存在精度丢失问题;
SELECT SUM(f1) FROM test_double2



# ======================== 12章节讲解: 04定点数类型 ========================

# DECIMAL(M,D); DEC; NUMERIC
CREATE TABLE test_decimal1(
                              f1 DECIMAL,
                              f2 DECIMAL(5,2)
);

# 有效的数据范围是由M和D决定的, 没有设置精度和标度时, 默认为(10,0)
DESC test_decimal1;

# 存在四舍五入
INSERT INTO test_decimal1(f1,f2) VALUES(123, 123.456), (123.456, 999.99);

# Out of range value for column 'f2' at row 1
INSERT INTO test_decimal1(f2) VALUES(1234.34);

# 测试DECIMAL 的精度:
CREATE TABLE test_decimal2(
                              f1 DECIMAL(5,2)
);
INSERT INTO test_decimal2 VALUES(0.47),(0.44),(0.19);
# 1.10; 无精度丢失
SELECT SUM(f1) FROM test_decimal2;



# ======================== 12章节讲解: 05位类型 ========================
# BIT(M); (M)是表示二进制的位数，位数最小值为1，最大值为64
CREATE TABLE test_bit1(
                          f1 BIT,
                          f2 BIT(5),
                          f3 BIT(64)
);
# 没有指定M时, 默认为1; 表示只能存1位的二进制值;
DESC test_bit1;

INSERT INTO test_bit1(f1) VALUES(1);

# 插入数值2时, 认为是十进制, 转为二进制为10, 超过f1的范围; Data too long for column 'f1' at row 1
INSERT INTO test_bit1(f1) VALUES(2);

INSERT INTO test_bit1(f2) VALUES(23);

SELECT * FROM test_bit1;

# 用SELECT命令查询位字段时，可以用 BIN() 或 HEX() 函数进行读取(二进制与16进制)
SELECT BIN(f1), BIN(f2), HEX(f1), HEX(f2)
FROM test_bit1;

# 通过 +0 以十进制形式查询
SELECT f1 + 0, f2 + 0 FROM test_bit1;



# ======================== 12章节讲解: 06日期与时间类型 ========================

USE dbtest12;

# 1. YEAR类型
CREATE TABLE test_year(
                          f1 YEAR,
                          f2 YEAR(4)
);
# 没有指定(4)的情况下, 同样为(4);
DESC test_year;

# 使用标准默认格式(YYYY)时, 字符串或者数值都会进行类型隐式转换;
INSERT INTO test_year VALUES('2020', 2021);

# YEAR取值范围为: 1901至2155: Out of range value for column 'f2' at row 1
INSERT INTO test_year VALUES('2155', '2156');


# 2. DATE类型
CREATE TABLE test_date1(
                           f1 DATE
);

DESC test_date1;

# YYYYMMDD格式会被转化为YYYY-MM-DD格式;
INSERT INTO test_date1 VALUES ('2020-10-01'), ('20201001'),(20201001);

INSERT INTO test_date1
VALUES ('00-01-01'), ('000101'), ('69-10-01'), ('691001'), ('70-01-01'), ('700101'),('99-01-01'), ('990101');

# 插入当前时间
INSERT INTO test_date1 VALUES (CURRENT_DATE()), (NOW());

SELECT * FROM test_date1;


# 3. TIME类型
CREATE TABLE test_time1(
                           f1 TIME
);
# 'D HH:MM:SS' 、' HH:MM:SS '、' HH:MM '、' D HH:MM '、' D HH '或' SS '
INSERT INTO test_time1 VALUES('2 12:30:29'), ('12:35:29'), ('12:40'), ('2 12:40'),('1 05'), ('45');
# 'HHMMSS'或者 HHMMSS 或者 MMSS(00MMSS)
INSERT INTO test_time1 VALUES ('123520'), (124011),(1210);

INSERT INTO test_time1 VALUES (NOW()), (CURRENT_TIME());

SELECT * FROM test_time1;


# 4. DATETIME类型
CREATE TABLE test_datetime1(
                               dt DATETIME
);
INSERT INTO test_datetime1 VALUES ('2021-01-01 06:50:30'), ('20210101065030');

INSERT INTO test_datetime1 VALUES ('99-01-01 00:00:00'), ('990101000000'), ('20-01-01 00:00:00'), ('200101000000');

INSERT INTO test_datetime1 VALUES (20200101000000), (200101000000), (19990101000000), (990101000000);

# 添加当前时间
INSERT INTO test_datetime1 VALUES (CURRENT_TIMESTAMP()), (NOW());


# 4. TIMESTAMP类型
CREATE TABLE test_timestamp1(
                                ts TIMESTAMP
);

INSERT INTO test_timestamp1 VALUES ('1999-01-01 03:04:50'), ('19990101030405'), ('99-01-01 03:04:05'), ('990101030405');

INSERT INTO test_timestamp1 VALUES ('2020@01@01@00@00@00'), ('20@01@01@00@00@00');

INSERT INTO test_timestamp1 VALUES (CURRENT_TIMESTAMP()), (NOW());

# 时间范围: “1970-01-01 00:00:01 UTC”至“2038-01-19 03:14:07 UTC”: Incorrect datetime value
INSERT INTO test_timestamp1 VALUES ('2038-01-20 03:14:07');

SELECT *  FROM test_timestamp1;


# 对比DATETIME与TIMESTAMP
CREATE TABLE temp_time(
                          d1 DATETIME,
                          d2 TIMESTAMP
);

INSERT INTO temp_time VALUES('2021-9-2 14:45:52','2021-9-2 14:45:52');
INSERT INTO temp_time VALUES(NOW(),NOW())

SELECT *  FROM temp_time;

# 修改当前的时区后再次查询, TIMESTAMP类型的数值与修改时区前有变化;
SET time_zone = '+9:00';
SELECT *  FROM temp_time;
/*
1. TIMESTAMP存储空间比较小，表示的日期时间范围也比较小;
2. 底层存储方式不同: TIMESTAMP底层存储的是毫秒值 (距离1970-1-1 0:0:0 0)
3. 日期比较大小或日期计算时，TIMESTAMP更方便、更快(毫秒值为数值类型, 会更快)
4. TIMESTAMP和时区有关: TIMESTAMP会根据用户的时区不同，显示不同的结果。而DATETIME则只能反映出插入时当地的时区，其他时区的人查看数据必然会有误差的。
*/



# ======================== 12章节讲解: 07文本字符串类型 ========================

# 1. CHAR(M); M为字符数; 范围0 <= M <= 255
CREATE TABLE test_char1(
                           c1 CHAR,
                           c2 CHAR(5)
);
# 没有指明M时, 默认为1;
DESC test_char1;

# 插入数据较短时, 会在右侧插入空格, 但是在查询时会去除空格;
INSERT INTO test_char1 VALUES('a','Tom');

# 检索时去除空格: 查询结果中数值与星号之间没有空格
SELECT c1,CONCAT(c2,'***') FROM test_c

    INSERT INTO test_char1(c2) VALUES('a ');
# 检索时去除空格: 即时插入时有空格, 查询时依然会去除空格
SELECT CHAR_LENGTH(c2) FROM test_char1


                                # 2. VARCHAR(M):
/*
	1. 定义时必须指定M值, 与CHAR(M)相同的是M都为字符数;
	2. M的取值范围与字符集有关, InnoDB 行大小限制非 BLOB列 ≤ 65535字节, 其中包括: 长度前缀 + 字符数据
			长度前缀: 用于记录实际长度（长度 ≤255 时用 1 字节，>255 时用 2 字节）
			字符数据: 示例: 假如长度两个字节, 一个字符需要3个字节, 那么字符长度:  n ≤ (65535-2)/3 ≈ 21844
	3. 检索VARCHAR类型的字段数据时，保留数据尾部的空格(CHAR(M)会去除空格);
*/
# 需指定M
CREATE TABLE test_varchar1(
                              `name` VARCHAR #错误
);

#字符长度计算: Column length too big for column 'NAME' (max = 21845);
CREATE TABLE test_varchar2(
                              `name` VARCHAR(65535) #错误
);

# 正确创建表
CREATE TABLE test_varchar3(
                              `name` VARCHAR(5)
);

INSERT INTO test_varchar3 VALUES('尚硅谷'),('尚硅谷教育');

# 他妈的这里三个空格, 总共六个字符, 插入数据时只保留了两个, 也没有报错, 这啥几把情况
INSERT INTO test_varchar3 VALUES('尚硅谷   ')

SELECT CHAR_LENGTH(`name`) FROM test_varchar3
SELECT `name`,CONCAT(`name`,'***') FROM test_varchar3

                                            # 包含 STRICT_TRANS_TABLES 即为启用严格模式;
SELECT @@sql_mode

           # 超过字符长度: Data too long for column 'NAME' at row 1
INSERT INTO test_varchar3 VALUES('尚硅谷IT教育');


# 3. TEXT类型
/*
	1. TEXT类型不用加默认值, 加了也没用;
*/
CREATE TABLE test_text(
                          tx TEXT
);
INSERT INTO test_text VALUES('atguigu ');
# 8个字符, 不会去除空格
SELECT CHAR_LENGTH(tx) FROM test_text;



# ======================== 12章节讲解: 08ENUM类型 ========================

CREATE TABLE test_enum(
                          season ENUM('春','夏','秋','冬','unknow')
);
DESC test_enum;
SELECT * FROM test_enum;

INSERT INTO test_enum VALUES('春'),('秋');
# 仅允许插入单个枚举项: Column count doesnt match value count at row 1
INSERT INTO test_enum VALUES('春','秋');

# 忽略大小写
INSERT INTO test_enum VALUES('UNKNOW');

# 指定索引位置的枚举值
INSERT INTO test_enum VALUES('1'),(3);

# 只能从枚举项中选择: Data truncated for column 'season' at row 1
INSERT INTO test_enum VALUES('ab');

# 当ENUM类型的字段没有声明限制非空时，插入NULL也是有效的
INSERT INTO test_enum VALUES(NULL);



# ======================== 12章节讲解: 09SET类型 ========================

CREATE TABLE test_set(
s SET ('A', 'B', 'C')
);
SELECT * FROM test_set;

# 插入数据时允许选择一个或多个(枚举类型仅允许选择一个)
INSERT INTO test_set (s) VALUES ('A'), ('A,B');

# 会自动删除重复的成员
INSERT INTO test_set (s) VALUES ('A,B,C,A');

# 只能从SET成员中选择: Data truncated for column 's' at row 1
INSERT INTO test_set (s) VALUES ('A,B,C,D');

# 没有限制非空时, 可以插入NULL
INSERT INTO test_set (s) VALUES (NULL);


# 练习示例:
CREATE TABLE temp_mul(
gender ENUM('男','女'),
hobby SET('唱','跳','RAP','篮球')
);

INSERT INTO temp_mul VALUES('男','唱,篮球');

# 枚举仅允许从枚举项中选择, 且仅允许选择一个; Data truncated for column 'gender' at row 1
INSERT INTO temp_mul VALUES('男,女','跳,篮球');

# 枚举仅允许从枚举项中选择, 且仅允许选择一个; Data truncated for column 'gender' at row 1
INSERT INTO temp_mul VALUES('沃尔玛购物袋','RAP,篮球');

INSERT INTO temp_mul VALUES('男','唱,RAP,篮球');



# ======================== 12章节讲解: 10二进制字符串类型 ========================

# 1. BINARY(M)与VARBINARY(M)类型; M表示字节数;
/*
	BINARY(M): 固定长度; 未指定M时默认为1;
	VARBINARY(M): 可变长度; 必须指定M;
*/
CREATE TABLE test_binary1(
f1 BINARY,
f2 BINARY(3),
# f3 VARBINARY,
f4 VARBINARY(10)
);
DESC test_binary1;

# 测试过程暂以一个英文字母表示一个字节
INSERT INTO test_binary1(f1,f2) VALUES('a','abc');

# Data too long for column 'f1' at row 1
INSERT INTO test_binary1(f2) VALUES('尚'); # 失败

INSERT INTO test_binary1(f2,f4) VALUES('ab','ab');
SELECT LENGTH(f2),LENGTH(f4) FROM test_binary1


# 2. BLOB类型
CREATE TABLE test_blob1(
 id INT,
 img MEDIUMBLOB
 );


# 3. JSON类型
CREATE TABLE test_json(
 js json
);

INSERT INTO test_json (js) VALUES ('{"name":"songhk", "age":18, "address":{"province":"beijing", "city":"beijing"}}');

SELECT * FROM test_json;

# 通过“->”和“->>”符号，从JSON字段中正确查询出了指定的JSON数据的值。
SELECT
	js -> '$.name' AS NAME,
	js -> '$.age' AS age ,
		js -> '$.address.province' AS province,
		js -> '$.address.city' AS city
FROM test_json;


