
# ======================== 07章节:单行函数 ========================


# ======================== 07章节讲解: 02数值函数-01基本函数 ========================
/*

ABS(x)		返回x的绝对值
SIGN(X)		返回X的符号。正数返回1，负数返回-1，0返回0
PI()			返回圆周率的值

CEIL(x), CEILING(x)		返回大于或等于某个值的最小整数; (天花板函数); 向上取整
FLOOR(x)							返回小于或等于某个值的最大整数; (地板函数); 向下取整

LEAST(e1,e2,e3…)			返回列表中的最小值
GREATEST(e1,e2,e3…)		返回列表中的最大值

MOD(x,y)		返回X除以Y后的余数; 取模(16%5=1)

RAND()			返回0~1的随机值
RAND(x)			返回0~1的随机值，相同的X值会产生相同的随机数, 其中x的值 用作 种子值，

ROUND(x)				返回一个对x的值进行四舍五入后，最接近于X的整数
ROUND(x,y)			返回一个对x的值进行四舍五入后最接近X的值，并保留到小数点后面Y位
TRUNCATE(x,y)		返回数字x截断为y位小数的结果
SQRT(x)					返回x的平方根。当X的值为负数时，返回NULL

*/
# 基本数值操作
SELECT
    ABS(-123),ABS(32),
    SIGN(-23),SIGN(43),
    PI(),
    CEIL(32.32),CEILING(-43.23),
    FLOOR(32.32),
    FLOOR(-43.23),
    MOD(16,5), 16 % 5
FROM DUAL;

# 随机数
SELECT
    RAND(),RAND(),			# 每次的随机值是不同的
    RAND(10),RAND(10),	# 传有相同种子值时, 随机值相同
                                RAND(-1),RAND(-1)		# 传有相同种子值时, 随机值相同
FROM DUAL;

# 四舍五入
SELECT
    ROUND(12.33),
    ROUND(12.343,2),ROUND(12.324,-1)
FROM DUAL;

# 截断操作(去尾法)
SELECT
    TRUNCATE(12.66,1), TRUNCATE(12.66,-1)
FROM DUAL;

# 单行函数可以嵌套
SELECT
    TRUNCATE(ROUND(293.395,2),1)
FROM DUAL;


# ======================== 07章节讲解: 02数值函数-02角度与弧度互换函数 ========================
# RADIANS(x)	将角度转化为弧度，其中，参数x为角度值
# DEGREES(x)	将弧度转化为角度，其中，参数x为弧度值
SELECT
    RADIANS(30),RADIANS(60),RADIANS(90),
    DEGREES(2*PI()),
    DEGREES(RADIANS(60))
FROM DUAL;


# ======================== 07章节讲解: 02数值函数-03三角函数 ========================
/*
SIN(x)		返回x的正弦值，其中，参数x为弧度值
ASIN(x)		返回x的反正弦值，即获取正弦为x的值。如果x的值不在-1到1之间，则返回NULL

COS(x)		返回x的余弦值，其中，参数x为弧度值
ACOS(x)		返回x的反余弦值，即获取余弦为x的值。如果x的值不在-1到1之间，则返回NULL

TAN(x)			返回x的正切值，其中，参数x为弧度值
ATAN(x)			返回x的反正切值，即返回正切值为x的值
ATAN2(m,n)	返回两个参数的反正切值

COT(x)		返回x的余切值，其中，X为弧度值
*/


# ======================== 07章节讲解: 02数值函数-04指数与对数 ========================
/*
POW(x,y), POWER(X,Y)		返回x的y次方
EXP(X)					返回e的X次方，其中e是一个常数，2.718281828459045
LN(X)，LOG(X)		返回以e为底的X的对数，当X <= 0 时，返回的结果为NULL
LOG10(X)				返回以10为底的X的对数，当X <= 0 时，返回的结果为NULL
LOG2(X)					返回以2为底的X的对数，当X <= 0 时，返回NULL

*/


# ======================== 07章节讲解: 02数值函数-05进制之间的转换 ========================
/*
BIN(x)		返回x的二进制编码
HEX(x)		返回x的十六进制编码
OCT(x)		返回x的八进制编码
CONV(x,f1,f2)		返回f1进制数变成f2进制数
*/
SELECT
    BIN(10),HEX(10),OCT(10),CONV(10,2,8)
FROM DUAL;



# ======================== 07章节讲解: 03字符串函数 ========================

# INSERT(str, idx, len, replacestr)		将字符串str从第idx位置开始，len个字符长的子串替换为字符串replacestr
# 字符串的索引都是从1开始
SELECT INSERT('hello,world!',6,1,'---') FROM DUAL;

# REPLACE(str, a, b)		用字符串b替换字符串str中所有出现的字符串a, (有a就替换, 没有就不替换, 不会报错)
SELECT REPLACE('hello','ll','aa'), REPLACE('hello','ee','aa') FROM DUAL;

# LPAD(str, len, pad)		用字符串pad对str最左边进行填充，直到str的长度为len个字符
# 实现左对齐效果
SELECT employee_id, last_name, LPAD(salary, 10, '*') FROM employees;	# 这里salary进行了隐式转换, 转为了字符串;
SELECT employee_id, last_name, LPAD(salary, 10, ' ') FROM employees;

# RPAD(str ,len, pad)		用字符串pad对str最右边进行填充，直到str的长度为len个字符
# 实现右对齐效果

# TRIM(s)		去掉字符串s首尾的空格, 中间的不会去除
SELECT CONCAT('---', TRIM('    he  l  l  o    '), '---') FROM DUAL;

# TRIM(s1 FROM s)		去掉字符串s首尾的s1
SELECT TRIM('oo' FROM 'ooheoollo') FROM DUAL;

# STRCMP(s1,s2)		比较字符串s1,s2的ASCII码值的大小; s1较大返回1, 相等返回0, s1较小返回-1
SELECT STRCMP('abc', 'abd') FROM DUAL;

# LOCATE(substr,str)		返回字符串substr在字符串str中首次出现的位置，作用与POSITION(substr IN str)、INSTR(str,substr)相同。
# 未找到时返回0; 理解: 如果找到位置, 最小为1, 因为MySQL中字符串的索引从1开始, 如果没找到, 那返回1前面的数值, 即为0;
# 类比: 在Java中如果indexOf()没找到返回-1, java中索引从0开始, 返回0前面的数值, 即为-1;
SELECT LOCATE('ll', 'hello') FROM DUAL;

# ELT(m,s1,s2,…,sn)		返回指定位置的字符串，如果m=1，则返回s1，如果m=2，则返回s2，如果m=n，则返回sn
# 用法可以为: m和s均为函数, 通过控制m的传值, 达到选择执行不同s的效果
SELECT ELT(2, 'a', 'b', 'c', 'd') FROM DUAL;

# NULLIF(value1,value2)比较两个字符串，如果value1与value2相等，则返回NULL，否则返回value1
SELECT NULLIF('zhangsan', 'lisi') FROM DUAL;



# ======================== 07章节讲解: 04日期和时间函数-01获取日期,时间 ========================
# 日期转为数值的隐式转换
SELECT
    CURDATE(), 			# 2025-06-05
	CURDATE() + 0,	# 20250605
	NOW(),					# 2025-06-05 01:09:34
	NOW() + 0				# 20250605010934
FROM DUAL;


# ======================== 07章节讲解: 04日期和时间函数-02日期与时间戳的转换 ========================
# 略


# ======================== 07章节讲解: 04日期和时间函数-03获取月份,星期,星期数,天数等函数 ========================

# WEEKDAY(date)		返回周几，注意，周1是0，周2是1，。。。周日是6
# 2025-06-05, 周四, 返回3
SELECT WEEKDAY('2025-06-05') FROM DUAL;

# DAYOFWEEK(date)		返回周几，注意：周日是1，周一是2，。。。周六是7
# 2025-06-05, 周四, 返回5
SELECT DAYOFWEEK('2025-06-05') FROM DUAL;


# ======================== 07章节讲解: 04日期和时间函数-04日期的操作函数 ========================

# EXTRACT(type FROM date)		返回指定日期中特定的部分，type指定返回的值
SELECT EXTRACT(DAY FROM NOW()) FROM DUAL;


# ======================== 07章节讲解: 04日期和时间函数-05时间和秒钟转换的函数 ========================

# TIME_TO_SEC(time)		将 time 转化为秒并返回结果值。转化的公式为: 小时*3600+分钟*60+秒
# SEC_TO_TIME(seconds)	将 seconds 描述转化为包含小时、分钟和秒的时间
SELECT
    TIME_TO_SEC('2025-06-05 00:30:10'),
    TIME_TO_SEC('00:30:10'),
    SEC_TO_TIME(100000)		# 27:46:40
FROM DUAL;


# ======================== 07章节讲解: 04日期和时间函数-06计算日期和时间的函数 ========================
# DATE_ADD(datetime, INTERVAL expr type), ADDDATE(date,INTERVAL expr type)		增加, date为给定时间参数, expr为表达式, type为时间间隔类型
# DATE_SUB(date,INTERVAL expr type), SUBDATE(date,INTERVAL expr type)					减少, date为给定时间参数, expr为表达式, type为时间间隔类型
SELECT
    DATE_ADD('2025-06-05 00:30:10', INTERVAL 1 DAY),		# 增加一天
    DATE_ADD('2025-06-05 00:30:10', INTERVAL '1_1' YEAR_MONTH)	# 增加一年和一个月; 这里表达式为'1_1', 中间拼接下划线
FROM DUAL;

# ADDTIME(time1,time2)	返回time1加上time2的时间。当time2为一个数字时，代表的是秒，可以为负数
# SUBTIME(time1,time2)	返回time1减去time2后的时间。当time2为一个数字时，代表的是秒，可以为负数
# MAKEDATE(year,n)			针对给定年份与所在年份中的天数返回一个日期
SELECT
    ADDTIME(NOW(),20),			# 当为数字时，代表秒
	SUBTIME(NOW(),'1:1:3'),	# 代表时分秒
    SUBTIME(NOW(),'1:3'),		# 代表时分

    MAKEDATE('2024-02-01', 60),		# 2024年，的第六十天
	MAKEDATE(YEAR(NOW()),50),			# YEAR()对NOW()函数取年数值，即本年，的第五十天

	PERIOD_ADD(20200101010101, 10)	# 即2020-01-01 01:01:01，这是日期转为数值的形式
FROM DUAL;


# ======================== 07章节讲解: 04日期和时间函数-07日期的格式化与解析 ========================
# 格式化: 日期 ---> 字符串
# 解析: 字符串 ---> 日期
# 此处讲解显式格式化和解析
# 隐式格式化: 当字符串满足默认的日期格式时, 就会隐式格式化
SELECT * FROM employees WHERE hire_date = '1993-01-13';

/*
DATE_FORMAT(date,fmt)		按照字符串fmt格式化日期date值
TIME_FORMAT(time,fmt)		按照字符串fmt格式化时间time值

GET_FORMAT(date_type,format_type)		返回日期字符串的显示格式

STR_TO_DATE(str, fmt)								按照字符串fmt对str进行解析为一个日期
*/
# 格式化
SELECT
    DATE_FORMAT(CURDATE(),'%Y-%m-%d'),
    TIME_FORMAT(CURTIME(),'%H:%i:%S'),
    DATE_FORMAT(NOW(),'%y-%M-%D %W %r')
FROM DUAL;

# 解析: 解析时保证字符串的格式与格式符对应, 而且提前测试一下, 因为有可能会转失败
SELECT
    STR_TO_DATE('25-June-6th Friday 11:15:00 PM','%y-%M-%D %W %r')
FROM DUAL;

# 返回一种日期格式
SELECT GET_FORMAT(DATE, 'EUR') FROM DUAL;
# 使用示例
SELECT
    DATE_FORMAT(NOW(), GET_FORMAT(DATETIME, 'USA'))
FROM DUAL;



# ======================== 07章节讲解: 05流程控制函数 ========================

# 01: IF(value,value1,value2)		如果value的值为TRUE，返回value1，否则返回value2
# 计算员工的年薪
SELECT
    last_name, commission_pct, salary,
    salary * 12 * (1 + IF(commission_pct IS NOT NULL, commission_pct, 0)) AS '年薪'
FROM employees;

# 假设employees表中, is_amdmin字段有0和1两个值, 现在将两个值对调
UPDATE employees SET is_admin = IF(is_admin = 1, 0, 1);


# 02: IFNULL(value1, value2)		如果value1不为NULL，返回value1，否则返回value2
# 计算员工的年薪
SELECT
    last_name, commission_pct, salary,
    salary * 12 * (1 + IFNULL(commission_pct, 0)) AS '年薪'
FROM employees;


/*
03:
CASE WHEN 条件1 THEN 结果1
			WHEN 条件2 THEN 结果2
			....
			[ELSE resultn]
			END												相当于Java的if...else if...else...(多选一; ELSE可以省略(一般使用[]符号的都可以省略) )
*/
SELECT
    last_name, salary,
    CASE
        WHEN salary >= 15000 THEN 'A'
        WHEN salary >= 10000 THEN 'B'
        WHEN salary >= 5000 THEN 'C'
        ELSE 'D'
        END AS 'salaryGrade',
        department_id
FROM employees;

/*
04:
CASE expr
	WHEN 常量值1 THEN 值1
	WHEN 常量值1 THEN 值1
	....
	[ELSE 值n]
	END												相当于Java的switch...case...(多选一; ELSE可以省略(一般使用[]符号的都可以省略) )
*/
# 查询部门号为 10,20, 30 的员工信息, 若部门号为 10, 则打印其工资的 1.1 倍, 20 号部门, 则打印其工资的 1.2 倍, 30 号部门打印其工资的 1.3 倍数。
SELECT
    last_name, salary, department_id,
    CASE department_id
        WHEN 10 THEN salary * 1.1
        WHEN 20 THEN salary * 1.2
        WHEN 30 THEN salary * 1.3
        END 'afterSalary'
FROM employees
WHERE department_id IN (10, 20, 30);
