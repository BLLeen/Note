# MyBatis

1. 根据 JDBC 规范建立与数据库的连接。
2. 通过反射打通**Java对象**和**数据库参数**和**返回值**之间相互转化的关系。

# 依赖

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
```

spring Bean配置

```xml
	<!-- druid数据库连接池 -->
  <bean id="mysqlDataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
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
	<bean id="DataSource" class="org.apache.ibatis.datasource.pooled.PooledDataSource">
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

	 <!-- 会话工厂bean sqlSessionFactoryBean -->
   <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!-- 数据源 -->
        <property name="dataSource" ref="h2DataSource"></property>
        <!-- sql映射文件路径 -->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
    </bean>

 		<!-- 自动扫描对象关系映射 -->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <!--指定会话工厂，如果当前上下文中只定义了一个则该属性可省去 -->
        <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"></property>
        <!-- 指定要自动扫描接口的基础包，实现接口 -->
        <property name="basePackage" value="com.xiong.demo.spring.dao.inter"></property>
    </bean>
```

 ![](/Users/qudian/Documents/MySpace/Note/pic_图片/mybatis流程.png)

### 配置总结

可以这么总结Mybatis或者帮助理解Mybatis的配置，我总结了以下三点提供参考：

- 一切Mybatis配置都是为了创建SqlSession进行SQL查询；
- 归根结底程序代码中我们屏蔽了各种配置映射，只显式调用使用Mapper接口，那么接口实现类的获得是通过SqlSession.getMapper()获得；
- 那么mapper接口实现类的获得是通过mybatis-config.xml->SqlSessionFactoryBuilder->SqlSessionFacotry->SqlSession->mapper；

## mybatis-spring

MyBatis-Spring 会帮助你将 MyBatis 代码无缝地整合到 Spring 中。它将允许 MyBatis 参与到 Spring 的**事务管理**之中，创建映射器 mapper 和 **`SqlSession`** 并注入到 bean 中，以及将 Mybatis 的异常转换为 Spring 的 **`DataAccessException`**。最终，可以做到应用代码不依赖于 MyBatis，Spring 或 MyBatis-Spring。



# 实现

## 1. 根据 JDBC 规范建立与数据库的连接。



#### 1. 数据类创建
创建数据类用来保存数据,成员设置成setXxx()格式,类似与bean,或者就是bean。
#### 2. 创建Mapper接口
XxxMapper接口用来定义一个个sql操作对于的方法方法,用来映射到接下来的Mapper配置文件中来映射sql操作,并设置参数，就像preparstatement里的占位符，可以通过方法 @Param("字段名")参数传入。然后返回值为数据类对象,或者就是简单数据类型。
<br><strong>不用去实现这个接口<strong>

#### 3. 创建Mapper.xml配置文件
配置文件用来将sql语句映射到接口方法中,并将返回的结果配置在一结果类的bean中,有一对一的映射,一对多的映射,以及多对多的映射
一对一映射resultMap类型(association)

```xml
    <!---->
    <mapper namespace="com.xiong.Mapper接口">
        <resultMap id="对象id" type="数据类">
            <result property="成员变量1" column="字段名" />
            <association property="成员变量2" javaType="类名">   
                <id property="id" column="t_id"/>
                <result property="name" column="t_name"/>
            </association>
        </resultMap>
        <!-- 根据id查询用户 -->
        <select id="方法名" parameterType="参数的数据类型" resultMap="resultMap对象id">
            sql语句 //用#{0},#{1}通过参数次序决定
                    //Mapper接口中方法每个用参数@Param("字段名")标注
        </select>
    </mapper>
    <!--通过resultType类型映射-->
    <mapper namespace="com.xiong.ActorMapper">
        <select id="findByname" parameterType="com.xiong.Actor" resultType="int">
            SELECT actor_id FROM actor WHERE first_name=#{first_name} AND last_name=#{last_name}
        </select>
    </mapper>
```
一对多映射resultMap类型(使用collection)
<br>(对于resultType一对多是方式似乎比较少,resultType在一对一上确实很好用,比这个要来的方便一些)
```xml
<mapper namespace="com.yc.mapper.CustomerMapper"> 
  <resultMap type="com.yc.m.Customer" id="resultCustomerMap"> 
    <result column="id" jdbcType="INTEGER" property="id" />
    <result property="address" column="address"/> 
    <result property="postcode" column="postcode"/> 
    <result property="sex" column="sex"/> 
    <result property="cname" column="cname"/> 
    <collection property="orders" ofType="com.yc.m.Orders">
          <result property="id" column="id"/>
          <result property="code" column="code"/>
    </collection>
  </resultMap> 

  <select id="getCustomer" resultMap="resultCustomerMap" parameterType="int"> 
    SELECT * 
    FROM t_customer 
    WHERE id=#{id} 
  </select>      
</mapper> 
```
多对多映射resultMap类型
<br>多对多的关系是A中有多个B,B中有多个A
<br>需要创建三个数据类,A类,B类,A_B类,A_B为A与B存在关系
```xml

```
resultMap类型会映射到一个resultMap指定的成员变量进行映射
<br>resultType类型则会映射到类的对象中返回,但是成员变量需要和字段名相同才能映射
<br>namespace属性用来指定Mapper接口

##### 配置框架数据库配置文件
用来配置数据库连接,事务管理,环境配置等
```
properties(属性)将数据库url,驱动名,用户密码写在单独的db.properties里
settings(全局配置参数)
typeAliases(类型别名)
typeHandlers(类型处理器)
objectFactory(对象工厂)
plugins(插件)
environments(环境集合属性对象)可以有多个环境用来对应不同的数据库,但是一个SqlSessionFactory只能对应一个数据库，创建多个SqlSessionFactory
--environment(环境子属性对象)
----transactionManager(事务管理) 有type="[JDBC|MANAGED]"两种,JDBC是直接使用JDBC的事务管理。MANAGED是使用使用容器的事务管理。使用Spring框架时不用进行配置,Spring会使用自带的事务管理模块
----dataSource(数据源)
mappers(映射器)
```
![setting参数](http://pcpj2g4mj.bkt.clouddn.com/18-8-4/11246893.jpg)
```xml
<!-- 配置文件的根元素 -->  
<configuration>  
    <!-- 属性：定义配置外在化 -->  
    <properties>
    </properties>  
    <!-- 设置：定义mybatis的一些全局性设置 -->  
    <settings>  
       <!-- 具体的参数名和参数值 -->  
       <setting name="" value=""/>   
    </settings>  
    <!-- 类型名称：为一些类定义别名 -->  
    <environments default="">  
       <!-- 环境变量：可以配置多个环境变量，比如使用多数据源时，就需要配置多个环境变量 -->  
       <environment id="">
          <!-- 事务管理器 -->  
          <transactionManager type="[JDBC|MANAGE]">
          <!--使用JDBC使用JDBC原装的事务管理-->
          </transactionManager>  
          <!-- 数据源 -->  
           <dataSource type="POOLED"> <!--连接池-->
                <property name="driver" value="${jdbc.driver}"/>
                <property name="url" value="${jdbc.url}"/>
                <property name="username" value="${jdbc.username}"/>
                <property name="password" value="${jdbc.password}"/>
            </dataSource> 
       </environment>   
    </environments>  
    <!-- 映射器：指定映射文件或者映射类 -->  
    <mappers>
        <mapper resource="ActorMapper.xml"/><!--指定映射文件-->
        <!--试过指定映射类但是出现问题，感觉指定映射配置文件，在映射文件里namespace配置映射类蛮合理的-->
    </mappers>  
</configuration>  
```
Mapper配置文件中${}与#{}
<br>#{}会将传来的参数加上""做字符串处理,一般String类型，查询语句用到#{}
<br>${}则直接添加上去，会直接参与编译,影响预编译,创建表格等使用
<br>对于返回的结果集resultType为数据类型或自定义的类，对于多条数据，可以在Mapper接口指定List<E>返回值。
在Application的主类中需要实现
```java
        try {
            //获取Mybatis配置
           Reader reader= Resources.getResourceAsReader(MyBatisConfig.xml);

        }catch (IOException ioe){
            System.out.println(ioe);
        }
        //创建工厂类--通过配置属性生成SqlSession类
        SqlSessionFactory  sessionFactory=new SqlSessionFactoryBuilder().build(reader);
        SqlSession session=sessionFactory.openSession();
        Actor actor =session.selectOne("findByid",10);//获取查询返回值
        List<Actor> actors=session.selectList("findAll");//获取查询返回值List
        ActorMapper actorMapper=session.getMapper(ActorMapper.class);//通过反射技术获取Mapper接口的实例化
        int result =actorMapper.insertActor(201,"leen","songxiong",new Date());//Mapper接口通过方法映射到配置文件的sql插入操作
        session.commit();//这是个事务，需要提交才能修改成功
        session.close();//关闭session对话

```