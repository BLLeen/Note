# JDBC
Java数据库连接(JDBC)由一组用 Java 编程语言编写的类和接口组成。JDBC提供了一个标准的API，使他们能够用纯Java API 来编写数据库应用程序，一套Java访问数据库的统一规范。具体与数据库交互的还是由驱动实现。
<br>先从使用出发进行介绍总结

# 依赖MySQL
com.mysql.jdbc.Driver 是 mysql-connector-java 5中的。
<br>com.mysql.cj.jdbc.Driver 是 mysql-connector-java 6中的。mysql5.6及以上。

# 使用

## 加载驱动
(将java语言翻译成数据库语言的程序)
```java
Class.forName("com.mysql.jdbc.Driver");

/*com.mysql.cj.jdbc.Driver类*/
static {
try {
    java.sql.DriverManager.registerDriver(new Driver());
    } catch (SQLException E) {
        throw new RuntimeException("Can't register driver!");
    }
}
```
在Class.forName加载完驱动类后(并且会将类对象初始化)，开始执行静态代码块，会new一个Driver，并调用DriverManager的registerDriver把Driver给注册到自己的驱动程序管理器(DriverManager)中去。
<br>com.mysql.jdbc.Driver继承NonRegisteringDriver类实现了java.sql.Driver接口。

**Driver接口:**
```java
public interface Driver {

    //获取Connection 方法。数据库的url，及info至少得包含user，password key
    Connection connect(String url, java.util.Properties info)throws SQLException;

    //判断是否是一个正确的url字符串。
    boolean acceptsURL(String url) throws SQLException;

    //得到驱动的属性(user，password，port等)。
    DriverPropertyInfo[] getPropertyInfo(String url, java.util.Properties info) throws SQLException;

    //得到主要版本
    int getMajorVersion();

    //得到次要版本
    int getMinorVersion();

    //判断是否是一个正确的driver
    boolean jdbcCompliant();

    //------------------------- JDBC 4.1 -----------------------------------
    //返回父日志
    public Logger getParentLogger() throws SQLFeatureNotSupportedException;
}

```

## 驱动管理： 
DriverManager,在com.mysql.jdbc.Driver类的静态初始化块中会向java.sql.DriverManager注册它自己 ,注册驱动首先就是初始化，然后把驱动的信息封装一下放进一个叫做DriverInfo的驱动信息类中，最后放入一个驱动的集合中。

## 获取数据库连接
数据库连接的本质其实就是客户端维持了一个和远程MySQL服务器的一个**TCP长连接**，并且在此连接上维护了一些信息。getConnection()建立和MysqlServer的Socket连接，二、连接成功后，进行登录校验, 发送用户名、密码、当前数据库连接默认选择的数据库名。

```java
Connection connection = DriverManager.getConnection(url,userId,passWord);
```

**Connection源码:**
```java
public interface Connection  extends Wrapper, AutoCloseable {
    //创建statement
    Statement createStatement() throws SQLException;

    //创建prepareStatement
    PreparedStatement prepareStatement(String sql)throws SQLException;

    //创建CallableStatement,调用存储过程
    CallableStatement prepareCall(String sql) throws SQLException;

    //转换sql为本机执行sql
    String nativeSQL(String sql) throws SQLException;

    //设置是否自动提交 状态
    void setAutoCommit(boolean autoCommit) throws SQLException;

    //判断是否是自动提交
    boolean getAutoCommit() throws SQLException;

    //提交
    void commit() throws SQLException;

    //回滚
    void rollback() throws SQLException;

    //关闭连接
    void close() throws SQLException;

    //判断是否关闭
    boolean isClosed() throws SQLException;

}

```

## 语句对象接口 
- Statement
通过Connection的createStatement()创建的过程就是先检查是否还保持连接，如果ok，设置了一些结果集展示的属性，如最大行数，字符编码等。

```java
String SQL;
Statement statement = connection.createStatement();
statement.executeQuery(SQL);
```

```
有三种方法
1、createStatement();
2、createStatement(int resultSetType, int resultSetConcurrency)
3、createStatement(int resultSetType, int resultSetConcurrency, int resultSetHoldability)

resultSetType可选值:
   1、ResultSet.TYPE_FORWARD_ONLY           只能向前移动游标，
   2、ResultSet.TYPE_SCROLL_INSENSITIVE     向前向后移动游标，
   3、ResultSet.TYPE_SCROLL_SENSITIVE       向前向后移动游标，同时值有所改变的时候，可得到最新的值

resultSetConcurrency可选值:
   1、ResultSet.CONCUR_READ_ONLY  在ResultSet中的数据记录是只读的，不可以修改
   2、ResultSet.CONCUR_UPDATABLE  在ResultSet中的数据记录可以任意修改，然后更新会数据库

resultSetHoldability可选值:
   1、ResultSet.HOLD_CURSORS_OVER_COMMIT 表示修改提交时,不关闭ResultSet的游标
   2、ResultSet.CLOSE_CURSORS_AT_COMMIT  表示修改提交时,关闭ResultSet的游标

默认值就是在获得ResultSet的值后，只能向后移动，只读的。
```

- PreparedStatement

PreparedStatement与Statement相比主要区别在于
1. 占位符

```java
PreparedStatement  preparedStatement= con.prepareStatement("select * from users where NAME = ? and PWD = ?");
stmt.setString(1, username);
stmt.setString(2, password);
```

2. 预编译
预编译是SQL进行的，将sql语句预编译为执行函数，然后PreparedStatement持有相对应的key。
<br>以MySQL为例
<br>执行预编译分为如三步：
1. 执行预编译语句，例如：prepare myfun from 'select * from t_book where bid=?'
2. 设置变量，例如：set @str='b1'
3. 执行语句，例如：execute myfun using @str

<br>再次执行myfun，那么就不再需要第一步，即不需要再编译语句了：
1. 设置变量，例如：set @str='b2'
2. 执行语句，例如：execute myfun using @str


3. 防止注入攻击(将SQl的所有的特殊字符使用\转义)
PreparedStatement去写sql语句时，程序会对该条sql首先进行预编译，然后会将传入的字符串参数以字符串的形式去处理，即会在参数的两边自动加上单引号('param')，而Statement则是直接简单粗暴地通过人工的字符串拼接的方式去写sql，那这样就很容易被sql注入。并且将特殊字符使用转义字符" \ "
```sql
select * from user where name = ?

? = (张三' or 1='1)

select * from user where name = '张三' or 1='1'

转义后

select * from user where name = '张三 \' or 1=\' 1'
将''变为字符来处理，而不是双引号。

```


- CallableStatement

调用存储过程，具体使用方式以后在研究


## 结果集接口 

```java

ResultSet resultSet = preparedStatement.executeQuery();
if (resultSet.next()) 
{
    String resultStr = resultSet.getString("name");
}

```

### ResultSet.next()源码分析:

```java
public boolean next() throws SQLException 
{
    synchronized (checkClosed().getConnectionMutex()) 
    {
        if (this.onInsertRow) 
        {
                this.onInsertRow = false;
        }
        if (this.doingUpdates) 
        {
            this.doingUpdates = false;
        }
        boolean b;
        if (!reallyResult()) 
        {
            throw SQLError.createSQLException(Messages.getString("ResultSet.ResultSet_is_from_UPDATE._No_Data_115"), SQLError.SQL_STATE_GENERAL_ERROR,getExceptionInterceptor());
            }
        if (this.thisRow != null) 
        {
            this.thisRow.closeOpenStreams();
        }
        if (this.rowData.size() == 0) 
        {
            b = false;
        } 
        else 
        {
            this.thisRow = this.rowData.next();
            if (this.thisRow == null) 
            {
                b = false;
            } 
            else 
            {
                clearWarnings();
                b = true;
            }
        }
        setRowPositionValidity();
        return b;
        }
    }
    
```

# JDBC事务


# 连接池 

