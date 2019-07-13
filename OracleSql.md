
#### Oracle使用distinct等价改写
低效：
```SQL
　　SELECT DISTINCT DEPT_NO,DEPT_NAME 
　　FROM DEPT D,EMP E 
　　WHERE D.DEPT_NO = E.DEPT_NO
```
高效写法：
```sql
　　SELECT DEPT_NO,DEPT_NAME 
　　FROM DEPT D 
　　WHERE EXISTS (SELECT 'X'
　　FROM EMP E 
　　WHERE E.DEPT_NO = D.DEPT_NO);
```
#### TRUNCATE语句和DELETE语句的区别
- truncate 为DDL，是清空表数据，删除后对字段默认初始值从1开始。因为对表清空
- delete 是DML，删除数据，字段默认初始值从已设置最大初始值开始。

#### 排序一般使用索引字段进行排序

#### null与null比较为false，一般用is null判断
```sql
delete from tablename where x is null ;
```
#### 对索引字段使用函数操作过程中不会使用该字段索引
#### length,lenghtb,substr,substrb
加上b为按字节操作
```sql
SELECT length('叶德华abc') -- length按字符计，汉字、英文、数字都是1个字符，故这里返回6
  FROM dual;
SELECT lengthb('叶德华abc') -- length按字节计，我这里是UTF-8编码，汉字3个字节，英文一个字节，故这里返回12
  FROM dual;
SELECT substr('叶德华abc', 1,4)-- substr按字符截取，截取到a，返回：叶德华a
  FROM dual;
SELECT substrb('叶德华abc',1,2) -- substrb按字节截取，2不足一个汉字长度，返回：两个空格
  FROM dual;
SELECT substrb('叶德华abc',1,3) -- substrb按字节截取，3刚好是一个汉字长度，返回：叶
  FROM dual;
SELECT substrb('叶德华abc',1,4) -- substrb按字节截取，4多余一个汉字少于两个汉字，返回：叶 加一个空格
  FROM dual;
```
#### oracle中nvl(函数)
NVL(表达式1，表达式2)如果表达式1为空值，NVL返回值为表达式2的值，否则返回表达式1的值。
<br>表达式1和表达式2的数据类型必须为同一个类型
<br>类似mysql中的ifnull(表达式1，表达式2)

#### 有null的字段无法建立索引，将null改为特殊定义的字符表示来建立索引

#### count(字段)对null值不会计入

不变的数据可以设置冗余字符

#### 临时表
- 数据库层面临时表，session临时表，事务级临时表，存储中间数据,会话结束或者事务结束的时候，这个临时表中的数据，不用用户自己删除，数据库自己会自动清除。

1. 会话级:会话结束清除

```sql

create global temporary table CUX.CUX_2_INV_MTL_TRX_TEMP
(
  trx_line_id             NUMBER,
  inventory_item_id       NUMBER,
  organization_id         NUMBER, 
  quantity                NUMBER
)
on commit preserve rows;
-- Grant/Revoke object privileges
grant select, insert, update, delete on CUX.CUX_2_INV_MTL_TRX_TEMP to APPSERP;
grant select on CUX.CUX_2_INV_MTL_TRX_TEMP to APPSQUERY;

```

2. 事务级:commit,rollback,会话结束，都会清除

```sql
create global temporary table CUX.CUX_2_INV_MTL_TRX_TEMP
(
  trx_line_id             NUMBER,
  inventory_item_id       NUMBER,
  organization_id         NUMBER, 
  quantity                NUMBER
)
on commit delete rows;

```

#### 执行计划
查看执行数据库过程计划，可以看出执行长短
table | type | possible_keys | key | key_len | ref | rows | Extra
|-----|-------|--------------|------|---------|----|------|-----|
- table 
显示这一行的数据是关于哪张表的
- type 
这是重要的列，显示连接使用了何种类型。从最好到最差的连接类型为const、eq_reg、ref、range、indexhe和ALL
- possible_keys 
显示可能应用在这张表中的索引。如果为空，没有可能的索引。可以为相关的域从WHERE语句中选择一个合适的语句
- key 
实际使用的索引。如果为NULL，则没有使用索引。
- key_len 
使用的索引的长度。在不损失精确性的情况下，长度越短越好
- ref 
显示索引的哪一列被使用了，如果可能的话，是一个常数
- rows 
MYSQL认为必须检查的用来返回请求数据的行数
- Extra 
关于MYSQL如何解析查询的额外信息

#### 约束

#### 视图：简化复制查询

- 普通视图不会优化速度
```sql
CREATE VIEW view_name AS select语句
```
- 物化视图(MATERIALIZED VIEW)会生成数据，但是是异步的，定时同步数据
```sql
CREATE MATERIALIZED VIEW bxj_objects_mv_t2 REFRESH FORCE AS SELECT * FROM bxj_objects_t2

```
```
1. 刷新的方式

Fast //增量刷新

Complete//完全刷新

Fource

2. 刷新的方法

DBMS_REFRESH.Refresh

DBMS_MVIEW.Refresh

```
- 针对表，比如数据字典，可以在不同数据库创建同名视图，保证程序可以跨平台使用

#### oracle主键通过创建序列进行自增与mysql主键自增长auto_increment不同

```sql
create sequence [schema.]sequence_name  
    [increment by n]  
    [start with n]  
    [maxvalue n|nomaxvalue]  
    [minvalue n|nominvalue]  
    [cycle|nocycle]  
    [cache|nocache]  
    [order|noorder]；  
  
INCREMENT BY: 指定序列号之间的间隔，该值可以为正或者负整数，但不可为0. 默认值为1；  
START WITH: 指定生成的第一个序列号，在升序时，序列从比最小值大的值开始，默认值为序列的最小值。对于降序，序列从比最大值小的值开始，默认值为序列的最大值；  

MAXVALUE: 指定序列可生成的最大值；  

NOMAXVALUE: 为升序指定最大值为POWER(10,27)，为降序指定最大值为-1；  

MINVALUE: 指定序列的最小值；  

NOMINVALUE: 为升序指定最小值为1，为降序指定的最小值为POWER(-10,26)；  

CYCLE：以指示在达到它的最大值或最小值之后，该序列将继续产生值。在一个上升序列到达它的最大值后，它会产生最小值。在一个递减序列到达它的最小值之后，它会产生最大值。  

NOCYCLE：当序列到达最大值或者最小值后，该序列不能产生值；这是默认的选项；  

CACHE：指定数据库在内存中预分配多少整数值用于快速访问。这个整数值可以是小于等于28位，最小值为2. 最大缓存的值必须小于等于下面公式计算出的值：  
       (CEIL (MAXVALUE - MINVALUE)) / ABS (INCREMENT)  
NOCACHE: 指定数据库不预分配缓存值。如果没有指定CACHE和NOCACHE，数据库默认缓存20个序列值； 

ORDER: 指定order条件保证序列按请求顺序生成。此条件适用于RAC环境;  

NOORDER: 不保证序列按请求顺序生成; 默认是NOORDER； 

``` 
#### 伪列
伪列只能查询，不能进行增删改操作
- rownum：逻辑编号，常用于分页查询
- rowid：物理位置
#### 索引
索引也是一张表，包含主键以及索引字段,是给系统使用的，在频繁查询的表里创建索引加快速度，当是在插入修改的时候会开销大来维护索引表。
- 单列索引，可以有多个单列索引
- 多列索引，多列组成一个索引
- 普通索引

```sql
CREATE INDEX indexName ON 表名(字段名(length)); //Blob和Text必须指定length 
```
- 唯一索引

```sql
索引字段列的值是唯一的允许null，多列索引的组合值是唯一的
CREATE UNIQUE INDEX indexName ON 表名(字段名(length));
```
- 索引最左前缀原则
index(a,b,c)=index(a),index(a,b),index(a,b,c)，把最常使用的字段列放在最左边
- 位图索引，查询单一简单的查询
#### rollup
group by a,b,v with rollup
<br>会加上a的总和行，b的总和行，(a,b)的总和行，都生成在同一个表里
```sql
部门          员工       工资
A             ZHANG     100 
A             LI        200 
A             WANG      300 
A             ZHAO      400 
A             DUAN      500 
B             DUAN      600 
B             DUAN      700

SELECT 部门,员工,SUM(工资)AS TOTAL 
FROM DEPART 
GROUP BY  部门,员工  WITH ROLLUP
结果如下：
部门           员工       工资
A             DUAN       500 
A             LI         200 
A             WANG       300 
A             ZHANG      100 
A             ZHAO       400 
A             NULL       1500 
B             DUAN       1300 
B             NULL       1300 
NULL       	  NULL       2800
```
#### 设置变量

```sql
SET @rownum:=0;
SELECT @rownum:=@rownum+1 AS rownum, actor.* FROM actor;可以设置变量作增1序列随着结果输出
```
#### 类型转换
#### 子查询
WITH AS短语，也叫做子查询部分，是用来定义一个SQL片断，该SQL片断会被整个SQL语句所用到。
```sql
with A as (sith A as (select * from class);
select *from A  
先执行select * from class   得到一个结果，将这个结果记录为A  ，在执行select *from A ,语句A表只是一个别名,查询结果会被记录到临时表，当一个查询块名字和一个表名或其他的对象相同时，解析器从内向外搜索，优先使用子查询块名字，重复使用结果。类似临时物化视图

```


#### 日期操作
- 通过to_date()进行日期格式生成
```sql
to_date('2004-05-07 13:23:44','yyyy-mm-dd hh24:mi:ss')
```
- hh24 表示24小时制
- 获取当前系统时间sysdate
- 获取date的年月日时分秒的数字to_number(to_char(sysdate,'yyyy'/'mm'/'dd'/'h'/....))
- 获取两个时间的间距MONTHS_BETWEEN(end,begin);这是按月份为单位
- 日期自加，自减add_months(sysdate,num)正加负减 
- 英文格式显示日期to_char(hire_date,'dd-mon-yy','nls_date_language=american')
#### 字符拼接
mysql使用concat('xxx'+字段名+....)，可多个拼接
<br>oracle使用 || 进行拼接

#### 运算函数
- trunc(number) 取整，截断小数
    - trunc(number,-1)取到小数点后一位
    - trunc(number,1)将个位数取为0;
- mod(num1，num2)取模

#### or用union (all)替换会快

#### 截取
- substr(字段,左,右)
#### 最大值最小值问题
- 获取一个表(不进行分组)中某一字段的最大最小值的全行信息
```sql
select * from employees e where salary in (select max(salary) as maxsalary
from employees e)
```
#### 使用伪列获取单行数据
- 获得第一行数据，通过伪列 rownum =1进行条件筛选可以获得第一行数据
- 获取最后一行数据，select * from (select * from employees order by rownum desc) where rownum <=1
-------------07-27-----------
## 今日学习
### JAVA Spring
### bean
通过xml创建的,被注入属性的实例化对象
#### 属性
- class	指定用来创建 bean 的 bean 类。
- name	指定唯一的bean标识符。在基于XML的配置元数据中，可使用ID和/或name属性来指定 bean 标识符。
- scope	指定由特定的 bean 定义创建的对象的作用域
    - singleton 属性默认值，默认值在spring IoC容器仅存在一个Bean实例，Bean以单例方式存在，既在容器内共享一个对象
    - prototype	每次从容器中调用Bean时，都返回一个<strong>新的实例</strong>
    - request   每次HTTP请求都会创建一个新的Bean，该作用域仅适用于WebApplicationContext环境
    - session	同一个HTTP Session共享一个Bean，不同Session使用不同的Bean，仅适用于WebApplicationContext环境
    - global-session	一般用于Portlet应用环境，改作用于仅适用于WebApplicationContext环境
- constructor-arg	它是用来注入依赖关系的
- properties	它是用来注入依赖关系的
- autowiring mode	它是用来注入依赖关系的
- lazy-initialization mode	延迟初始化的 bean 告诉 IoC 容器在它第一次被请求时，而不是在启动时去创建一个 bean 实例。
- initialization 方法在 bean 的所有必需的属性被容器设置之后，调用回调方法的容器被销毁时，使用回调方法。

#### Bean的生命周期
Bean被实例化之后需要进行init，和destroy，初始化后不再使用需要将其移除容器，通过<bean>init-method，destroy-method属性指定初始化方法和销毁方法,这些方法在类内部被实现。

### Oracle SQL练习

#### case
具有两种格式:简单case函数和case搜索函数。
简单case函数
```sql
case sex
  when '1' then '男'
  when '2' then '女’
  else '其他' end

```
case搜索函数

```sql
case when sex = '1' then '男'
     when sex = '2' then '女'
     else '其他' end  
```
这两种方式，可以实现相同的功能。简单case函数的写法相对比较简洁，但是和case搜索函数相比，功能方面会有些限制，比如写判定式。case函数只返回第一个符合条件的值，剩下的case部分将会被自动忽略。
- 将sum与case结合使用，可以实现分段统计
如求男女人数
```sql
select
   sum(case u.sex when 1 then 1 else 0 end)男性,
   sum(case u.sex when 2 then 1 else 0 end)女性,
   sum(case when u.sex <>1 and u.sex<>2 then 1 else 0 end)性别为空
from users u;
```
#### to_char(date,'day')可得当前是星期几/'ddd'可得是一年之中第几天

#### 修改日期格式(对表进行操作)
ALTER session SET nls_date_format='yyyy-mm-dd hh24:mi:ss'
#### UTC时区偏移量
select TZ_OFFSET('地区') from dual;
日期格式大全
```SQL
Year:     
        yy   two digits 两位年                显示值:07
        yyy  three digits 三位年                显示值:007
        yyyy four digits 四位年                显示值:2007
Month:     
        mm    number     两位月              显示值:11
        mon    abbreviated 字符集表示          显示值:11月,若是英文版,显示nov    
        month spelled out 字符集表示          显示值:11月,若是英文版,显示november 
Day:     
        dd    number         当月第几天        显示值:02
        ddd    number         当年第几天        显示值:02
        dy    abbreviated 当周第几天简写    显示值:星期五,若是英文版,显示fri
        day    spelled out   当周第几天全写    显示值:星期五,若是英文版,显示friday       
        ddspth spelled out, ordinal twelfth
Hour:
        hh    two digits 12小时进制            显示值:01
        hh24 two digits 24小时进制            显示值:13
Minute:
        mi    two digits 60进制                显示值:45
Second:
        ss    two digits 60进制                显示值:25
其它
Q     digit         季度                  显示值:4
WW    digit         当年第几周            显示值:44
W    digit          当月第几周            显示值:1
24小时格式下时间范围为： 0:00:00 - 23:59:59....     
12小时格式下时间范围为： 1:00:00 - 12:59:59 ....
```
#### group by多个字段
GROUP BY X, Y意思是将所有具

有相同X字段值和Y字段值的记录放到一个分组里
#### 标量子查询
select子句中包含单行子查询, 使用到外部连接，或者使用到了聚合函数，就可以考虑标量子查询
```sql
select 列1 ,(select 表2列1 from 表2 where .....))
```
类似外接查询,连接查询结果
#### grouping set
类似与多个group by查询联合起来
<br>比如
```sql
select A , B from table group by grouping sets(A, B) 
查询结果等价于
select A , null as B  from table group by A  
union all  
select null as A ,  B  from table group by B 
```
结果等价但是效率不等价啊，union的效率不如grouping set来的高，union多次扫描表进行union而
聚合是一次性从数据库中取出所有需要操作的数据，在内存中对数据库进行聚合操作并生成结果。
#### 递归查询
```sql
with hgonext as
(
   select *,0 as level from EnterPrise where DepartManage='Tom' --初始查询
   union all 
   select h.*,h1.level+1 from EnterPrise h join hgonext h1 on h.ParentDept=h1.Department
   --查询父节点为上一次查询结果的节点，通过内连接，只显示有相等的结果
)
select * from hgonext
```
递归查询就有点类似与树的层次遍历，先父节点，在夫节点的子节点直到子节点为空(既结果为空)
- 首先执行"select *,0 as level from EnterPrise where DepartManage='Tom'",如果不是第一次执行将返回空结果，因为tom.parenDept不可能指向自己，所有返回空
- 执行到“select h.*,h1.level+1 from EnterPrise h join hgonext h1 on h.ParentDept=h1.Department”，子节点结果与整个表进行内连接，得到子节点的行

#### system用户没有闪回功能的，需要用切换普通用户
- 创建用户create user 用户名 identified by 密码;
- 查看当前用户
    - 1、查看当前用户拥有的角色权限信息：select * from role_sys_privs;
    - 查看当前用户的详细信息：select * from user_users;
    - 查看当前用户的角色信息：select * from user_role_privs;
- 查看当前数据库名字show parameter db_name;
- 查看当前数据库实例select * from v$instance(需要管理员权限)

#### group by 优化
```sql
explain select actor.first_name,actor.last_name,count(*)
from sakila.film_actor
inner JOIN sakila.actor USING(actor_id)
group by film_actor.actor_id;
```
优化避免排序
```sql
explain select actor.first_name,actor.last_name,c.cnt
from sakila.actor INNER JOIN(
select actor_id,count(*) as cnt from sakila.film_actor group by actor_id
) as c using(actor_id);
```
如果有过滤条件，建议添加到子查询中
#### limit的优化
<br>优化步骤1：使用有索引的列或者主键进行 Order by 操作；
<br>优化步骤2：记录上次返回的主键，在下次查询时使用主键过滤
<br>缺点：要求主键是顺序排序的，如果主键中间空缺了几行，会导致查询的结果不足于5行，要求主键顺序增长，连续的。不连续的话，可以加一个附加的列，自增长+索引，效果是一样的。

### 例子总结