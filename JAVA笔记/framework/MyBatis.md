# MyBatis 

1. 根据 JDBC 规范建立与数据库的连接。
2. 通过反射打通**Java对象**和**数据库参数**和**返回值**之间相互转化的关系。

⚠️**先不结合spring来使用，这样可以更加深入的了解**

# 依赖

```xml
<dependency>
  <groupId>org.mybatis</groupId>
  <artifactId>mybatis</artifactId>
  <version>3.4.6</version>
</dependency>
```

# 配置

## 1. Mapper.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.xiong.demo.mybatis_native.dao.inter.UserMapper" >
    <resultMap id="BaseResultMap" type="com.xiong.demo.mybatis_native.dao.entity.User" >
        <!-- id标签：指定查询列中的唯一标识，表的唯一标识，如果有多个字段组成唯一标识，配置多个id -->
        <!-- column：数据库字段-->
        <!-- property：pojo属性名 -->
        <!-- jdbcType: 对应数据库的字段类型-->
        <id column="id" property="id" jdbcType="BIGINT"/>
        <result column="user_id" property="userId" jdbcType="BIGINT"/>
        <result column="name" property="name" jdbcType="VARCHAR" />
        <result column="age" property="age" jdbcType="INTEGER" />
        <result column="address" property="address" jdbcType="VARCHAR" />
        <result column="create_time" property="createTime" jdbcType="TIMESTAMP"/>
        <result column="update_time" property="updateTime" jdbcType="TIMESTAMP"/>
    </resultMap>

    <resultMap id="userMapWithAddress" type="com.xiong.demo.mybatis_native.dao.entity.UserWithAddress" >
        <!-- id标签：指定查询列中的唯一标识，表的唯一标识，如果有多个字段组成唯一标识，配置多个id -->
        <!-- column：数据库字段-->
        <!-- property：pojo属性名 -->
        <!-- jdbcType: 对应数据库的字段类型-->
        <id column="id" property="id" jdbcType="BIGINT"/>
        <result column="user_id" property="userId" jdbcType="BIGINT"/>
        <result column="name" property="name" jdbcType="VARCHAR" />
        <result column="age" property="age" jdbcType="INTEGER" />
        <result column="create_time" property="createTime" jdbcType="TIMESTAMP"/>
        <result column="update_time" property="updateTime" jdbcType="TIMESTAMP"/>
        <!-- association：用于映射关联查询单个对象的信息 -->
            <!-- property: 映射到主类中哪个属性 -->
        <association property="address" javaType="com.xiong.demo.mybatis_native.dao.entity.Address">
            <id column="id" property="id" jdbcType="BIGINT"/>
            <result column="address" property="address" jdbcType="VARCHAR"/>
            <result column="code" property="code" jdbcType="VARCHAR"/>
        </association>
    </resultMap>

    <resultMap id="userMapWithOrder" type="com.xiong.demo.mybatis_native.dao.entity.UserWithOrder" >
        <!-- id标签：指定查询列中的唯一标识，表的唯一标识，如果有多个字段组成唯一标识，配置多个id -->
        <!-- column：数据库字段-->
        <!-- property：pojo属性名 -->
        <!-- jdbcType: 对应数据库的字段类型-->
        <id column="id" property="id" jdbcType="BIGINT"/>
        <result column="user_id" property="userId" jdbcType="BIGINT"/>
        <result column="name" property="name" jdbcType="VARCHAR" />
        <collection property="orderList" ofType="com.xiong.demo.mybatis_native.dao.entity.Order" javaType="java.util.ArrayList">
            <id column="o_id" property="id" jdbcType="BIGINT"/>
            <result column="o_user_id" property="userId" jdbcType="BIGINT"/>
            <result column="o_order_name" property="orderName" jdbcType="VARCHAR" />
            <result column="o_amount" property="amount" jdbcType="INTEGER" />
        </collection>
    </resultMap>

    <sql id="Base_Column_List" >
        id,user_id,name,age,address,create_time,update_time
    </sql>

    <select id="getUserByUserId" resultMap="BaseResultMap" parameterType="java.lang.Long" >
        select
        <include refid="Base_Column_List" />
        from user
        where user_id = #{userId,jdbcType=BIGINT}
    </select>

    <select id="getMapByUserId" resultType="HashMap" parameterType="java.lang.Long">
        select
        <include refid="Base_Column_List" />
        from user
        where user_id = #{userId,jdbcType=BIGINT}
    </select>

    <select id="getUserMapWithAddressByUserId" resultMap="userMapWithAddress" parameterType="java.lang.Long" >
        select u.*,o.*
        from `user` u inner join address a on(u.address = a.address)
        where u.user_id = #{userId,jdbcType=BIGINT}
    </select>

    <select id="getUserMapWithOrderByUserId" resultMap="userMapWithOrder" parameterType="java.lang.Long">
        select u.*,o.id o_id,o.user_id o_user_id,o.order_name o_order_name,o.amount o_amount
        from `user` u inner join `order` o on(u.user_id = o.user_id)
        where u.user_id = #{userId,jdbcType=BIGINT}
    </select>


    <insert id="insertUser" parameterType="com.xiong.demo.mybatis_native.dao.entity.User">
            insert into user
             (user_id,name,age,address,create_time,update_time)
             values
             (#{userId,jdbcType=BIGINT},#{name,jdbcType=VARCHAR},#{age,jdbcType=INTEGER},
             #{address,jdbcType=VARCHAR},#{createTime,jdbcType=TIMESTAMP},#{updateTime,jdbcType=TIMESTAMP});
    </insert>
</mapper>

```

### CRUD标签

#### select

- resultType：将结果集映射为java的对象类型。必须（和 resultMap 二选一）

  > 使用**resultType**进行**输出映射**，只有查询出来的列名和pojo中的属性名一致，该列才可以映射成功。
  > 如果查询出来的列名和pojo中的属性名**全部不一致**，没有创建pojo对象。
  > 只要查询出来的列名和pojo中的属性**有一个一致**，就会创建pojo对象。

  > (1)输出**单个pojo对象**，Mapper方法返回值是单个对象类型
  >
  > (2)输出**pojo对象list**，Mapper方法返回值是List\<Pojo>，resultType仍然是pojo类
  >
  > 生成的动态代理对象中是根据Mapper方法的**返回值类型**确定是调用selectOne或selectList
  >
  > (3)输出**hashmap**
  > 输出pojo对象可以改用HashMap输出类型，将输出的字段名称作为Map的key，value为字段值。如果是集合，那就是Mapper方法返回值List里面套了HashMap。

- resultMap：将结果集的字段做高级映射，比如字段名，n对n映射

  > jdbcType和javaType为字段映射时的数据类型，mybatis会有默认配置，个别特殊的可能会有问题。mysql中的「datetime」字段类型，对应的jdbcType位「TIMESTAMP」，java中的数据类型可以是java.util.Date（该类为父类）。

  - 1对1

    > 使用\<association>标签：用于映射关联查询单个对象的信息，该标签的property 属性：要将关联查询的表（表名） 映射到主类中哪个属性 。

  - 1对n

    > 使用\<cellection>标签：用于主POJO的list属性对应关联查询的多条数据。

  

- parameterType：传入参数类型。这个属性可以不写，Myabatis会自动识别。

  - 基本数据类型：#{参数|@Param()指定的参数名} 获取Mapper方法参数中的值
  - 复杂数据类型：#{类属性名}  ，Map中则是#{键名}

- statementType：指定如何操作SQL语句。

  - STATEMENT：Statement，直接操作sql，不进行预编译，使用**$**获取参数
  - PREPARED：（默认该方式）PreparedStatement，预处理，参数，进行预编译，使用**#**获取参数
  - CALLABLE：CallableStatement，执行存储过程
    

#### insert

- parameterType：参数的类型。
- useGeneratedKeys：**true**开启主键回写
- keyColumn：指定数据库的主键
- keyProperty：主键对应的pojo属性名

#### update

- parameterType：传入的参数类型。

#### delete

- parameterType：传入的参数类型。

### 动态SQL

#### sql片段

```xml
<!--定义片段-->
<sql id="">
</sql>

<!--使用片段-->
<include refId=""/>
```

#### if 判断(配合where标签)

if判断为true的才将sql语句添加进去，where 元素只会在**至少有一个子元素的条件返回 SQL 子句**的情况下才去插入“WHERE”子句。而且，若语句的开头为“AND”或“OR”，where 元素也会将它们去除。

```xml
<select>
  SELECT * FROM user
  <where>
    <if test="判断语句（sql的判断语句格式）">
    </if>
  </where>
</select>
```

#### choose, when, otherwise选择

类似于java的switch语句,选择其中的**从上到下第一个满足**条件的语句，如果都没有则选择otherwise标签内的。

```xml
<choose>
  <when test="title != null">
     AND title like #{title}
  </when>
  <when test="author != null and author.name != null">
     AND author_name like #{author.name}
  </when>
  <otherwise>
     AND featured = 1
  </otherwise>
</choose>
```

#### set

set 标签元素主要用在**更新操作**的，与if配合类似 where 标签元素，在包含的语句前输出一个**set**，然后如果包含的语句是以逗号结束的话将会把该逗号忽略，如果**set 包含的内容为空**的话则会**报错**。

```xml
<set>
  <if test="title != null">
    title = #{title},
  </if>
  <if test="content != null">
    content = #{content},
 	</if>
  <if test="owner != null">
    owner = #{owner}
  </if>
</set>
```

#### trim设置前后缀

- **prefix**="("                      给第一条符合条件的语句加上前缀"("
- **prefixOverrides**=","   将最后一条符合条件的语句前缀“(“去掉
- **suffix**=")"                       给第一符合条件的语句加上后缀")"
- **suffixOverrides**=","    将最后一条符合条件的语句后缀“,“去掉

```xml
<trim prefix="where" suffixOverrides="and">
  <if test="name!=null and name!=''">
    e.emp_name=#{name,jdbcType=VARCHAR} and
  </if>
  <if test="dep!=null">
    e.emp_dep=#{dep.id,jdbcType=INTEGER} and
  </if>
</trim>

<trim prefix="(" suffix=")" suffixOverrides="," >
  <if test="name!=null and name!=''">
    name,
  </if>
  <if test="dep!=null">
    dep,
  </if>
</trim>
```

#### foreach

- collection 要遍历的集合
- item 要遍历的元素
- index 元素在集合中的索引
- open 遍历以什么开头 比如 open="and id in ("
- seprator 遍历出来的元素以什么分隔
- end 遍历以什么结束 end=”)”

入参是需要遍历的数据类型

```xml
<foreach item="item" index="index" collection="list" open="(" separator="," close=")">
    #{item}
</foreach>
```

#### bind

bind 标签可以使用 OGNL 表达式创建一个变量井将其绑定到上下文中。

```xml
<select>
  <bind name="pattern" value="'%' + _parameter.getTitle() + '%'" />
  SELECT * FROM BLOG
  WHERE title LIKE #{pattern}
</select>
```

### XML 中有 5 个预定义的实体引用

| 实体引用 | 字符 | 字符名称 |
| -------- | ---- | -------- |
| \&lt;    | <    | 小于     |
| \&gt;    | >    | 大于\    |
| \&amp;   | &    | 和号     |
| \&apos;  | '    | 单引号   |
| \&quot;  | "    | 引号     |

注释：在 XML 中，只有字符 "<" 和 "&" 确实是非法的。大于号是合法的，但是用实体引用来代替它是一个好习惯。

**在CDATA内部的所有内容都会被解析器忽略**,这里<不会被转义。

```xml
<![CDATA[
SELECT * FROM `user` WHERE create_time < #{startTime} 
]]>
```







## 2. mybatis-config.xml

[mybatis-config.xml详解](https://mybatis.org/mybatis-3/zh/configuration.html)

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">
<!-- 根标签 -->
<configuration>
<!--配置信息，可以用${}在下文获取-->
	<properties>
    <property name="driver" value="com.mysql.jdbc.Driver"/>
    <property name="url" value="jdbc:mysql://127.0.0.1:3306/db?useUnicode=true;characterEncoding=utf-8"/>
    <property name="username" value="root"/>
    <property name="password" value="123456"/>
	</properties>
  
  <!--配置-->
  <settings>
    <setting name="cacheEnabled" value="false"/>
   	<setting name="lazyLoadingEnabled" value="true"/>
   	<setting name="aggressiveLazyLoading" value="true"/>
    <setting name="multipleResultSetsEnabled" value="true"/>
    <setting name="useColumnLabel" value="true"/>
    <setting name="useGeneratedKeys" value="false"/>
    <setting name="autoMappingBehavior" value="PARTIAL"/>
    <setting name="defaultExecutorType" value="SIMPLE"/>
    <setting name="defaultStatementTimeout" value="300"/>
    <!-- <setting name="mapUnderscoreToCamelCase" value="true"/> 自动转换大小写去除 -->
 </settings>
  <!-- 环境，可以配置多个，default：指定采用哪个环境 -->
  <environments default="test">
      <!-- id：唯一标识 -->
      <environment id="test">
         <!-- 事务管理器，JDBC类型的事务管理器 -->
         <transactionManager type="JDBC" />
         <!-- 数据源，池类型的数据源 -->
         <dataSource type="POOLED">
            <property name="driver" value="com.mysql.jdbc.Driver" />
            <property name="url" value="jdbc:mysql://127.0.0.1:3306/mybatis-110" />
            <property name="username" value="root" />
            <property name="password" value="123456" />
         </dataSource>
      </environment>
      <environment id="development">
         <!-- 事务管理器，JDBC类型的事务管理器 -->
         <transactionManager type="JDBC" />
         <!-- 数据源，池类型的数据源 -->
         <dataSource type="POOLED">
            <property name="driver" value="${driver}"/> 
            <property name="url" value="${url}"/>
            <property name="username" value="${username}" />
            <property name="password" value="${password}" />
         </dataSource>
      </environment>
  </environments>
  <!--mapper xml映射文件-->
  <mappers>
    <mapper resource="mappers/UserMapper.xml"/>
    <mapper resource="mappers/UserMapper1.xml"/>
    <!--使用@Mapper的Mapper接口-->
    <mapper class="com.xiong.demo.mybatis_native.dao.entity.UserMapper"/>
    <!--使用@Mapper的Mapper接口的包-->
    <package name="com.xiong.demo.mybatis_native.dao.entity"/>
  </mappers>
</configuration>

```

### 事务

- JDBC事务管理

  ```xml
  <transactionManager type="JDBC"/>
  <!--代码中需要手动SqlSession.commit()提交。-->
  ```

- 使用MANAGED的事务管理

  ```xml
  <transactionManager type="MANAGED"/>
  ```

  这种机制mybatis自身**不实现事务管理**，而是让程序的容器（Spring）来实现对事务的管理。









## 3. java代码中使用demo

```java
// 指定全局配置文件
private static String resource = "mybatis-config.xml";
// 读取配置文件
InputStream inputStream = Resources.getResourceAsStream(resource);
// 构建sqlSessionFactory
sqlSessionFactory= new SqlSessionFactoryBuilder().build(inputStream);
// 获取sqlSession
SqlSession sqlSession = sqlSessionFactory.openSession();
// 操作CRUD，第一个参数：指定statement，规则：namespace.sqlId
		// 第二个参数：指定传入sql的参数,这里1L是UserId
/**
*直接使用SqlSession来进行CRUD
**/
User user = sqlSession.selectOne("UserMapper.getUserByUserId", 1L);

/**
*使用Mapper实现类来进行CRUD
**/



```



 ![](/Users/qudian/Documents/MySpace/Note/pic_图片/mybatis流程.png)



## 配置总结

可以这么总结Mybatis配置，我总结了以下三点提供参考：

- 一切Mybatis配置都是为了创建SqlSession进行SQL查询；
- 归根结底程序代码中我们屏蔽了各种配置映射，只显式调用使用Mapper接口，那么接口实现类的获得是通过SqlSession.getMapper()获得；
- 那么mapper接口实现类的获得是通过mybatis-config.xml->SqlSessionFactoryBuilder->SqlSessionFacotry->SqlSession->mapper；



# Mybatis生命周



#### SqlSession

**参考资料**：[从源码的角度解析Mybatis的会话机制](http://objcoding.com/2019/03/20/mybatis-sqlsession/)

- mybatis创建sqlsession经过了以下几个主要步骤：

  1. 从核心配置文件mybatis-config.xml中获取**Environment**（这里面是数据源）；

  2. 从Environment中取得**DataSource**；

  3. 从Environment中取得**TransactionFactory**；

  4. 从DataSource里获取数据库连接对象**Connection**；

  5. 在取得的数据库连接Connection上创建事务对象**Transaction**（每个SqlSession创建都会创建一个事物对象，因此sqlSession不能共享）；

  6. 创建**Executor**对象（该对象非常重要，事实上sqlsession的所有操作都是通过它完成的）；

  7. 创建**sqlsession**对象。

	> 如果多个请求**同一个事务**中，那么多个请求都在**共用**一个SqlSession，反之每个请求都会**创建**一个SqlSession

- 调用SqlSession.close()

  使用连接池，会将该连接disable，使之能被再使用。

# plug拦截器

**参考资料**

- [MyBatis 插件之拦截器(Interceptor)](https://blog.csdn.net/weixin_39494923/article/details/91534658)

@Intercepts标记了这是一个Interceptor，然后在@Intercepts中定义了两个@Signature，即两个拦截点。第一个@Signature我们定义了该Interceptor将拦截Executor接口中参数类型为MappedStatement、Object、RowBounds和ResultHandler的query方法；第二个@Signature我们定义了该Interceptor将拦截StatementHandler中参数类型为Connection的prepare方法。

```java
@Intercepts{@Signature(type = StatementHandler.class,method = "prepare",args = {Connection.class, Integer.class})}
```



# 缓存

# 延迟加载

# 实现





# 整合分页插件 pageHelper



# With Spring🍃



## 依赖

```xml
<dependency>
  <groupId>org.mybatis</groupId>
  <artifactId>mybatis</artifactId>
  <version>3.4.6</version>
</dependency>

<dependency>
  <groupId>org.mybatis</groupId>
 	<artifactId>mybatis-spring</artifactId>
	<version>1.3.2</version>
</dependency>
```

### mybatis-spring依赖包

MyBatis-Spring 会帮助你将 MyBatis 代码无缝地整合到 Spring 中。它将允许 MyBatis 参与到 Spring 的**事务管理**之中，创建映射器 mapper 和 **`SqlSession`** 并注入到 bean 中，以及将 Mybatis 的异常转换为 Spring 的 **`DataAccessException`**。最终，可以做到应用代码不依赖于 MyBatis，Spring 或 MyBatis-Spring。

## 配置

1. mybatis-config.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
  <!--配置-->
    <settings>
        <setting name="cacheEnabled" value="false"/>
        <setting name="lazyLoadingEnabled" value="true"/>
        <setting name="aggressiveLazyLoading" value="true"/>
        <setting name="multipleResultSetsEnabled" value="true"/>
        <setting name="useColumnLabel" value="true"/>
        <setting name="useGeneratedKeys" value="false"/>
        <setting name="autoMappingBehavior" value="PARTIAL"/>
        <setting name="defaultExecutorType" value="SIMPLE"/>
        <setting name="defaultStatementTimeout" value="300"/>
        <!-- <setting name="mapUnderscoreToCamelCase" value="true"/> 自动转换大小写去除 -->
    </settings>

    <!--mapper的ml映射文件，用于mapper接口 ：mapper xml文件映射-->
    <mappers>
        <mapper resource="mapper/user-mapper.xml"/>
    </mappers>
</configuration>


<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">
<!-- 根标签 -->
<configuration>
<properties>
	<property name="driver" value="com.mysql.jdbc.Driver"/>
	<property name="url" value="jdbc:mysql://127.0.0.1:3306/mybatis-110?useUnicode=true&amp;characterEncoding=utf-8&amp;allowMultiQueries=true"/>
	<property name="username" value="root"/>
    	<property name="password" value="123456"/>
   </properties>

   <!-- 环境，可以配置多个，default：指定采用哪个环境 -->
   <environments default="test">
      <!-- id：唯一标识 -->
      <environment id="test">
         <!-- 事务管理器，JDBC类型的事务管理器 -->
         <transactionManager type="JDBC" />
         <!-- 数据源，池类型的数据源 -->
         <dataSource type="POOLED">
            <property name="driver" value="com.mysql.jdbc.Driver" />
            <property name="url" value="jdbc:mysql://127.0.0.1:3306/mybatis-110" />
            <property name="username" value="root" />
            <property name="password" value="123456" />
         </dataSource>
      </environment>
      <environment id="development">
         <!-- 事务管理器，JDBC类型的事务管理器 -->
         <transactionManager type="JDBC" />
         <!-- 数据源，池类型的数据源 -->
         <dataSource type="POOLED">
            <property name="driver" value="${driver}" /> <!-- 配置了properties，所以可以直接引用 -->
            <property name="url" value="${url}" />
            <property name="username" value="${username}" />
            <property name="password" value="${password}" />
         </dataSource>
      </environment>
   </environments>
  </configuration>

```

spring Bean配置

```xml
	<!--1.配置数据源-->
	<!-- druid数据库连接池 -->
  <bean id="druidDataSource1" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
        <!-- 基本属性 url、user、password127.0.0.1 -->
        <property name="driverClassName" value="${jdbc.driver}" />
        <property name="url" value="${jdbc.url}" />
        <property name="username" value="${jdbc.username}" />
        <property name="password" value="${jdbc.password}"/>
        <!-- 配置初始化大小、最小、最大 -->
        <property name="initialSize" value="2" />
        <property name="minIdle" value="1" />
        <property name="maxActive" value="20" />

        <!-- 配置获取连接等待超时的时间 -->
        <property name="maxWait" value="60000" />

        <!-- 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒 -->
        <property name="timeBetweenEvictionRunsMillis" value="60000" />

        <!-- 配置一个连接在池中最小生存的时间，单位是毫秒 -->
        <property name="minEvictableIdleTimeMillis" value="300000" />

        <!-- 验证连接有效与否的SQL，不同的数据配置不同 -->

        <property name="validationQuery" value="SELECT 'x' from dual " />
        <property name="testWhileIdle" value="true" />
        <property name="testOnBorrow" value="false" />
        <property name="testOnReturn" value="false" />

        <!-- 打开PSCache，并且指定每个连接上PSCache的大小 -->
        <property name="poolPreparedStatements" value="true" />
        <property name="maxPoolPreparedStatementPerConnectionSize" value="20" />

        <!-- 配置监控统计拦截的filters -->
        <property name="filters" value="stat" />
  </bean>
	<!-- druid数据库连接池 -->
	<bean id="druidDataSource2" class="org.apache.ibatis.datasource.pooled.PooledDataSource">
        <!-- 基本属性 url、user、password -->
        <property name="driver" value="${jdbc.driver}" />
        <property name="url" value="${jdbc.url}" />
        <property name="username" value="${jdbc.username}" />
        <property name="password" value="${jdbc.password}"/>
  </bean>
	<!-- myabtis的数据库连接源 -->
  <bean id="h2DataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
        <!-- 基本属性 url、user、password -->
        <property name="driverClassName" value="${jdbc.driver}" />
        <property name="url" value="${jdbc.url}" />
        <property name="username" value="${jdbc.username}" />
        <property name="password" value="${jdbc.password}"/>
   </bean>

	 <!-- 2.会话工厂bean sqlSessionFactoryBean 用于生产SqlSession-->
   <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
       <!-- 数据源 -->
       <property name="dataSource" ref="h2DataSource"></property>
       <!-- sql映射文件路径 -->
       <property name="configLocation" value="classpath:mybatis-config.xml"/>
   </bean>

 	 <!-- 3.自动扫描对象关系映射 Mapper-->
   <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
       <!--指定会话工厂，如果当前上下文中只定义了一个则该属性可省去 -->
       <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"></property>
       <!-- 指定要自动扫描mapper接口的包，实现接口 -->
       <property name="basePackage" value="com.xiong.demo.spring.dao.inter"></property>
   </bean>
```