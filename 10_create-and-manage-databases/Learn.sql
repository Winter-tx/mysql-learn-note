
# ======================== 10章节:创建和管理表 ========================



# ======================== 010章节讲解: 01创建和管理数据库 ========================

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





