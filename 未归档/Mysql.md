### 添加数据

#### 为表中所有的字段添加数据
向表中添加的数据称之为记录。
两种方式：
##### 方式一：insert语句中指定所有字段名
在insert 语句中列出表中的所有字段名，其值与其字段名、类型要一一对应！ 
```
INSERT INTO 表名 (字段名1，字段名2，...)
        VALUES(值1，值2，...)
        VALUES(值1，值2，...)
        VALUES(值1，值2，...)

```

##### 方式二：insert语句中不指定字段名

```

INSERT INTO 表名 VALUES(值1，值2，....);

```
#### 只向部分字段添加值，而其他值为默认值

### 更新数据
```
UPDATE 表名
  SET  字段名1=值1 [,字段名2=值2，...] [WHERE 条件表达式] ;

```
### 删除数据
#### DELET
```
DELETE FROM 表名 [ WHERE 条件表达式 ]  ;

```
#### TRUNCATE
```
TRUNCATE [TABLE]   表名  ;
```
与delete语句区别： 
1. truncate 只能删除全部数据，delete 后可以有where。teuncate不会有记录，所有效率高
2. truncate删除数据后，再像表中添加记录时，自动增加字段的默认初始值重新由 1 开始。delete删除表中积累后，再次向其添加记录时，自动增加字段的值为删除时该字段的最大值加 1 

### 创建用户与授权

#### 创建用户

```
CREATE USER 'username'@'host' IDENTIFIED BY 'password';

```

#### 授权:
```
GRANT 操作(如SELECT，INSERT，UPDATE，ALL等) ON databasename.tablename TO 'username'@'host'

```
加上 WITH GRANT OPTION 可为其他用户授权

#### 设置与更改用户密码

为其他用户

```
SET PASSWORD FOR 'username'@'host' = PASSWORD('newpassword');
```
如果是当前登陆用户用:

```
SET PASSWORD = PASSWORD("newpassword");

```
#### 撤销用户权限

```
REVOKE 操作 ON databasename.tablename FROM 'username'@'host';

```
#### 删除用户

```
DROP USER 'username'@'host';
```
### 数据库成员

- 超级管理员用户（root），拥有全部权限
- 普通用户，由root创建，普通用户只拥有root所分配的权限

#### ResultSet没有提供获取大小的语句需要自己设置
1. 通过conn.prepareStatement(sql语句,TYPE_SCROLL_INSENSITIVE, CONCUR_READ_ONLY);
	- ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY // 可以滚动的
	- ResultSet.TYPE_FORWARD_ONLY // 只能向前滚动
	- ResultSet.TYPE_SCROLL_INSENSITIVE和Result.TYPE_SCROLL_SENSITIVE //实现任意的前后滚动
2. ResultSet.last();将结果滚到最后一条，int rowCount = resultSet.getRow()这个时候getRow就可以获取全部结果数
3. resultSet.beforeFirst();回滚到第一条，开始遍历查询

#### 查询非内容信息(表的属性等)

```
SHOW DATABASES                                //列出 MySQL Server 数据库。
SHOW TABLES [FROM db_name]                    //列出数据库数据表。
SHOW CREATE TABLES tbl_name                    //导出数据表结构。
SHOW TABLE STATUS [FROM db_name]              //列出数据表及表状态信息。
SHOW COLUMNS FROM tbl_name [FROM db_name]     //列出资料表字段
SHOW FIELDS FROM tbl_name [FROM db_name]，DESCRIBE tbl_name [col_name]。
SHOW FULL COLUMNS FROM tbl_name [FROM db_name]//列出字段及详情
SHOW FULL FIELDS FROM tbl_name [FROM db_name] //列出字段完整属性
SHOW INDEX FROM tbl_name [FROM db_name]       //列出表索引。
SHOW STATUS                                  //列出 DB Server 状态。
SHOW VARIABLES                               //列出 MySQL 系统环境变量。
SHOW PROCESSLIST                             //列出执行命令。
SHOW GRANTS FOR user                         //列出某用户权限

```

#### 表的修改
```sql

1.添加表字段
alter table 表名 add 字段名 数据类型(长度) not Null;非空

alter table   table1 add id int unsigned not Null auto_increment primary key;//auto_increment 是主键才能有的属性，自动增长值

2.修改某个表的字段类型及指定为空或非空
alter table 表名 modify 字段名称 字段类型 [是否允许非空];

3.修改某个表的字段名称及指定为空或非空
alter table 表名 change 字段名称 字段名称 字段类型 [not Null是否允许非空];

4.如果要删除某一字段，可用命令：
ALTER TABLE mytable DROP 字段名;

5.表重命名
alter table 表名 rename to 表重命名;

6.删除表
drop table 表名;

7.添加索引
ALTER table tableName ADD INDEX indexName(columnName)

8.修改索引
DROP INDEX [indexName] ON mytable; 

```

### Java中的Mysql事务

<br>四个特性
- 原子性
- 一致性
- 隔离性
- 持久性

<br>JDBC对java中的操作默认是自动提交，既Connection.setAutoCommit(true);设置为false就可以自己来提交事务
- Connection,begin();//事务开始
- Connection.commit(); //如果所有sql语句成功，则提交事务
- Connection.rollback();//只要有一个sql语句出现错误，则将事务回滚，既事务一致性都不修改

### 查询结果排序

order by 列名 DESC/ASC
```
select * from table1 order by 列名 DESC; // 降序

```

### AS的用法

as 给查询的结果字段取别名
```
SELECT username AS 账号,password AS 密码,FROM user;

```

### SQL的执行顺序：
1. 执行FROM
2. WHERE条件过滤
3. GROUP BY分组
4. 执行SELECT投影列
5. HAVING条件过滤
6. 执行ORDER BY 排序

### WHERE条件语句

```

=	等于
!=	不等于，某些数据库系统也写作 <>
>	大于
<	小于
>=	大于或等于
<=	小于或等于
BETWEEN … AND…	介于某个范围之内，例：WHERE age BETWEEN 20 AND 30

NOT BETWEEN …AND …	不在某个范围之内

IN(项1,项2,…)	在指定项内，例：WHERE city IN('beijing','shanghai')

NOT IN(项1,项2,…)	不在指定项内

LIKE 搜索匹配，常与模式匹配符配合使用
    % 通配符允许匹配任何字符串的零个或多个字符。
    _ 通配符允许匹配任何单个字符。

NOT LIKE LIKE的反义

IS NULL	空值判断符

IS NOT NULL	非空判断符

NOT、AND、OR	逻辑运算符，分别表示否、并且、或，用于多个逻辑连接。

优先级：NOT > AND > OR
%	模式匹配符，表示任意字串，例：WHERE username LIKE '%user'

```

### Mysql聚合函数

- COUNT：统计行数量

```
SELECT COUNT(< */All/DISTINCT >) FROM <表名> 条件

- * :计数所有选择的行，包括NULL值；

- ALL 列名：计数指定列的所有非空值行，如果不写，默认为ALL；

- DISTINCT 列名：计数指定列的唯一非空值行。

```

- SUM：获取单个列的合计值
- AVG：计算某个列的平均值
- MAX：计算列的最大值
- MIN：计算列的最小值

### 数据分组(GROUP BY (列名))

SQL中数据可以按列名分组，一般搭配聚合函数使用实用。

<br>例，统计每个班的人数:


```
SELECT student_class,COUNT(ALL 列名) FROM t_student GROUP BY (列名);
```

### HAVING过滤条件

可用于聚合函数的过滤条件,<strong>WHERE</strong>不可用于聚合函数

例查询平均年龄在20岁以上的班级

```
SELECT student_class,AVG(student_age) AS 平均年龄 FROM t_student GROUP BY (student_class) HAVING AVG(student_age)>20; 
```

### 子查询
子查询可以嵌套在主查询中所有位置，包括SELECT、FROM、WHERE、GROUP BY、HAVING、ORDER BY

#### 在SELECT中嵌套

```sql
如学生信息和班级名称位于不同的表中，要在同一张表中查出学生的学号、姓名、班级名称：

SELECT s.student_id,s.student_name,(SELECT class_name FROM t_class c WHERE c.class_id=s.class_id) FROM t_student s GROUP BY s.student_id; 

```

#### 在WHERE中嵌套：
```sql
如查C语言成绩最高的学生的信息：
SELECT * FROM t_student WHERE student_subject='C语言' AND student_score>=ALL (SELECT student_score FROM t_student WHERE student_subject='C语言');

```
#### 子查询运算符
- ALL运算符
　　和子查询的结果逐一比较，必须全部满足时表达式的值才为真。
- ANY运算符
　　和子查询的结果逐一比较，其中一条记录满足条件则表达式的值就为真。
- EXISTS/NOT EXISTS运算符
　　EXISTS判断子查询是否存在数据，如果存在则表达式为真，反之为假。NOT EXISTS相反。
在子查询或相关查询中，要求出某个列的最大值，通常都是用ALL来比较，大意为比其他行都要大的值即为最大值。

### 组合查询：
通过UNION运算符来将两张表纵向联接，基本方式为：
```sql
SELECT 列1 , 列2 FROM 表1
UNION
SELECT 列3 , 列4 FROM 表2;

```
- union :得到两个查询结果的并集，并且自动去掉重复行。不会排序 
- union all:得到两个查询结果的并集，不会去掉重复行。也不会排序 
- intersect:得到两个查询结果的交集，并且按照结果集的第一个列进行排序 
- minus:得到两个查询结果的减集，以第一列进行排序 


### 关联查询
#### 内连接查询

所有查询出的结果都是能够在连接的表中有对应记录的,既有关系的都会连接显示

```sql
select xxx from tablename1 inner jion teblename2 on 条件
```

```sql

//查询两表关联
select 
e.empName,d.deptName
from t_employee e
INNER JOIN t_dept d
ON e.dept = d.id;
```

#### 左外连接
是指以左边的表的数据为基准，去匹配右边的表的数据，如果匹配到就显示，匹配不到就显示为null
```sql
SELECT e.empName,d.deptName
from t_employee e
RIGHT OUTER JOIN t_dept d 
on d.id = e.dept;
```

#### 右外连接
同理，只是基准表的位置变化了而已

#### 全外连接
既有关联的进行关联，没关联的其他位置设为null
<br>mysql是没有全外连接的(mysql中没有full outer join关键字)，想要达到全外连接的效果，可以使用union关键字连接左外连接和右外连接。例如：

```sql
select e.empName,d.deptName
     FROM t_employee e 
     left JOIN t_dept d
     ON e.dept = d.id
UNION
select e.empName,d.deptName
     FROM t_employee e 
     RIGHT JOIN t_dept d
     ON e.dept = d.id;
```
#### 自连接查询

自连接查询就是当前表与自身的连接查询，关键点在于虚拟化出一张表给一个别名
```sql
SELECT e.empName,b.empName
     from t_employee e
     LEFT JOIN t_employee b
     ON e.bossId = b.id;
```

### 引擎

#### InnoDB

事务型的存储引擎，有行级锁定和外键约束
- 属于索引组织表

适用场景
- 经常性更新表，适合处理多重并发的更新请求
- 支持事务
- 恢复日志
- 外键约束
- 自动增加列属性auto_increment

#### MyIASM

- 属于堆表
- 不支持事务
- 锁定粒度在整个表上，插入较慢
- 不支持主动数据恢复
- 读取速度快

#### Memory(HAEP)

- 堆内存
- 存在内存中，默认使用Hash做索引
- 数据长度不变的格式如，[Blob](https://www.cnblogs.com/xiaohuochai/p/6535130.html)和Text'
- 支持散列索引和B树索引

适用场景

- 中间结果表，丢失关系不大的数据
- 数据较小
- 用完既删

#### Mrg_Myisam (实现水平分表)
MyISAM表的集合，表的列和索引信息相同
- 没有数据，真正的数据在MyISAM表中

数据大的时候水平分表可以方便查询。

#### Blackhole
任何写入的数据都会被丢弃，不做实际存储，select语句永远为空
- 验证dump file语法的正确性
- 用于记录binlog做复制的中继存储
- 充当日志服务器
通过往黑洞表写入数据，既将日志记录，将sql数据丢弃。

### 锁
[mysql的锁](https://www.cnblogs.com/luyucheng/p/6297752.html)

- 表级锁 粒度大
- 行级锁 粒度小，开销大，主要是InnoDB存储引擎使用
- 页级锁 适中

#### 锁的种类

<br>意向锁是InnoDB自动添加，不需用户干预。
<br>对于UPDATE、DELETE和INSERT语句，InnoDB会自动给涉及数据集加排他锁(X)；
<br>对于普通SELECT语句，InnoDB不会加任何锁；
<br>事务可以通过以下语句显示给记录集加共享锁或排他锁。
```sql
共享锁（S）：SELECT * FROM table_name WHERE ... LOCK IN SHARE MODE
排他锁（X)：SELECT * FROM table_name WHERE ... FOR UPDATE
```
##### 死锁
- MyISAM表锁是deadlock free的，这是因为MyISAM总是一次获得所需的全部锁，要么全部满足，要么等待，因此不会出现死锁。

### 范式
- 第一范式(1NF)：强调的是列的原子性，即列不能够再分成其他几列。 
- 第二范式(2NF)：首先是1NF，另外包含两部分内容，一是表必须有一个主键；二是没有包含在主键中的列必须完全依赖于主键，而不能只依赖于主键的一部分。 
- 第三范式(3NF)：首先是2NF，另外非主键列必须直接依赖于主键，不能存在传递依赖。即不能存在：非主键列 A 依赖于非主键列 B，非主键列 B 依赖于主键的情况。


### B+树
- B树

1. 根结点至少有两个子节点。
2. 每个中间节点都包含k-1个元素和k个孩子，其中 m/2 <= k <= m
3. 每一个叶子节点都包含k-1个元素，其中 m/2 <= k <= m
4. 所有的叶子结点都位于同一层。
5. 每个节点中的元素从小到大排列，节点当中k-1个元素正好是k个孩子包含的元素的值域分划。

- B+树新特性

1. 每个节点的元素都有一个对应的子节点。每个有k个子树的中间节点包含有k个元素(B树中是k-1个元素)，每个元素不保存数据，只用来索引，所有数据都保存在叶子节点。
2. 叶子节点包涵所有信息，从大到小排列，指针小到大顺序链接。所有的叶子结点中包含了全部元素的信息，及指向含这些元素记录的指针，且叶子结点本身依关键字的大小自小而大顺序链接。
3. 节点的元素就是对应子节点的最大(最小)元素。所有的中间节点元素都同时存在于子节点，在子节点元素中是最大（或最小）元素。



