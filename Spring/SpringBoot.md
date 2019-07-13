### property配置(现在主流是yml)
- @PropertySource(value = "classpath:test.properties")可以使用非application.property的配置使用自定义的配置
- @ConfigurationProperties(prefix = "xxx")可以用来自动匹配前缀为xxx的值
### 日志配置
日志文件是使用Logback作为日志框架,相对于log4j更加高效
### profile配置
```xml
<!-- 在上下文context-param中设置profile.default的默认值 -->
    <context-param>
        <param-name>spring.profiles.default</param-name>
        <param-value>development</param-value>
    </context-param>
    <!-- 在上下文context-param中设置profile.active的默认值 -->
    <!-- 设置active后default失效，web启动时会加载对应的环境信息 -->
    <context-param>
        <param-name>spring.profiles.active</param-name>
        <param-value>development</param-value>
    </context-param>

    <servlet>
        <servlet-name>appServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <!-- 在DispatcherServlet参数中设置profile的默认值，active同理 -->
        <init-param>
            <param-name>spring.profiles.default</param-name>
            <param-value>development</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>appServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
```
在代码中该注解@Profile("development")可使得该Bean只有在development环境下才能被创建
### Spring boot annotation列表

#### @SpringBootApplicatio
spring boot给程序自动进行配置
<br>等同于
- @Configuration(用来扫描该类下的@Bean并初始化spring容器)
- @EnableAutoConfiguration(将所有符合自动配置条件的bean定义加载到IoC容器,既配合@Configuration和@ComponentScan将所有符号条件的bean加载到Ioc容器中)

![EnableAutoConfiguration](http://pcpj2g4mj.bkt.clouddn.com/18-8-10/85673773.jpg)

- @ComponentScan(告诉Spring指定的packages的用注解标识的类,会被spring自动扫描并且装入bean容器)

### Springboot 与Mybatis整合

#### 通用Mapper类
通用Mapper类中包含了基本的数据库操作,可以使用其中的操作，如果不够可以使用自己写的方法
##### 通用Mapper的配置

- 基于 starter 的自动配置

在所有接口上添加@Mapper注解
<br>在properties配置文件中指定Mapper接口
```
mapper.mappers=com.hand.springbootmybatis.api.infra.mapper
## 是否判断字符串类型 !=''
mapper.not-empty=false
## 取回主键方式
mapper.identity=MYSQL
```
- 基于 @MapperScan 注解的手工配置

在有@Configuration的类配置该注解，或者配置到Spring Boot的启动类上
```java
@tk.mybatis.spring.annotation.MapperScan(basePackages = "扫描包")
```
##### @NameStyle 注解(Mapper)
这个注解可以在实体类上进行配置,可以用来使之与数据库的字段名相匹配，优先级高于对应的 style 全局配置。
```
normal,                     //原值
camelhump,                  //驼峰转下划线
uppercase,                  //转换为大写
lowercase,                  //转换为小写
camelhumpAndUppercase,      //驼峰转下划线大写形式
camelhumpAndLowercase,      //驼峰转下划线小写形式
```
##### @Table注解
注解在实体类中,配置 name,catalog 和 schema 三个属性，配置 name 属性后，直接使用提供的表名，不再根据实体类名进行转换。
##### @Column注解
配置在实体类的成员变量中使之对应数据库的字段，支持name,insertable和updateable三个属性。
```
name 配置映射的列名。
insertable 对提供的insert方法有效，如果设置false就不会出现在SQL中
updateable 对提供的update方法有效，设置为false后不会出现在SQL中
```

#### PageHelper
实现select * from table limit x,x操作然后将结果通过分页分成多页,在Spring boot下实现方法很简单只需在Controller中应用即可

```java
@RequestMapping("/")
Resultlist(HttoServletRequest request,HttpServletResponse respons,Model model,Integer page){
    PageHelper.startPage(page,everyNum);
    List<User> users = selectByList();
    PageInfo pageinfo =new PageInfo(users);
    model.addAttribute("page",page);
    model.addAttribute("users",users);  
}
```

## 注解积累
## @EnableAutoConfiguration
与大部分@Enable*注解类似，这个注解也是借助@import注解将符合条件的@Configuration定义加载到IOC容器内
### @Import(EnableAutoConfigurationImportSelector.class)
实现ImportSelector接口，通过注解进行选择 
## shiro安全框架
## spring admin
- 监控注册到admin server的admin client信息(基于actuator，其UI就是基于actuator端点)
- 通过url或者指定服务发现的注册中心的服务来注册
- 监控JMX
### server依赖包
```xml
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-server</artifactId>
    <version>2.0.1</version>
</dependency>
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-server-ui</artifactId>
    <version>2.0.1</version>
</dependency>
 <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
``` 
### client依赖包
```xml
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-client</artifactId>
    <version>2.0.1</version>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<!--因为端口的暴露，可以使用security保护-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<!--监控jvm为了获取jvm内的数据-->
```
### 启动
服务端注解，客户端不需要注解
```java
@EnableAdminServer
@@EnableWebSecurity
```
### 服务端配置
```yml
server:
  port: 8087
spring:
  application:
    name: admin-server
  security:            # 进入网站需要验证
      user:
        name: "root"
        password: "root"

eureka:
  instance:
    metadata-map:
      user.name: ${spring.security.user.name}           # 将密码赋给eureka
      user.password: ${spring.security.user.password}       
    leaseRenewalIntervalInSeconds: 10                   # 发送心跳间隔
    health-check-url-path: /actuator/health             # 默认atuator的端口
  client:
    registryFetchIntervalSeconds: 5                      # 从eureka获取信息的时间间隔 5秒
    service-url:
      defaultZone: http://localhost:8081/eureka/
info:
  version: @project.version@                             # 版本信息
management:
  endpoints:
    web:
      exposure:
        include: "*"                                    # 暴露端口
```
### 客户端接口
```yml
server:
  port: 8082
spring:
  application:
    name: demo-server
  profiles:
    active: test
  boot:
    admin:
      client:
        url: http://localhost:8087
        instance:   
          metadata:                                       # 将security密码告诉admin只能admin访问
            user.name: ${spring.security.user.name}     
            user.password: ${spring.security.user.password}
  security:
      user:
        name: root
        password: root

eureka:
  client:
    service-url:
      defaultZone: http://localhost:8081/eureka/
  instance:
    leaseRenewalIntervalInSeconds: 10
    health-check-url-path: /actuator/health
    metadata-map:
      user.name: ${spring.security.user.name}
      user.password: ${spring.security.user.password}
    lease-renewal-interval-in-seconds: 10
    health-check-url-path: /actuator/health
  
info:
  version:
    @project.version@

management:
  endpoints:
    web:
      exposure:
        include: "*"
  endpoint:
    health:
      show-details: ALWAYS

```

## WebFlux

### 特点
- Spring WebFlux是基于响应式流的，因此可以用来建立异步的、非阻塞的、事件驱动的服务。它采用Reactor作为首选的响应式流的实现库，不过也提供了对RxJava的支持。
- 由于响应式编程的特性，Spring WebFlux和Reactor底层需要支持异步的运行环境，比如Netty和Undertow；也可以运行在支持异步I/O的Servlet 3.1的容器之上，比如Tomcat(8.0.23及以上)和Jetty(9.0.4及以上)。
- spring-webflux上层支持两种开发模式： 
  - 类似于Spring WebMVC的基于注解（@Controller、@RequestMapping）的开发模式；
  - Java 8 lambda 风格的函数式开发模式。
- Spring WebFlux也支持响应式的Websocket服务端开发。

### 响应式Http客户端

此外，Spring WebFlux也提供了一个响应式的Http客户端API **WebClient**。它可以用函数式的方式异步非阻塞地发起Http请求并处理响应。其底层也是由Netty提供的异步支持。
<br>我们可以把WebClient看做是响应式的RestTemplate，与后者相比，前者：
- 是非阻塞的，可以基于少量的线程处理更高的并发；
- 可以使用Java 8 lambda表达式；
- 支持异步的同时也可以支持同步的使用方式；
- 可以通过数据流的方式与服务端进行双向通信。

### Spring WebFlux也提供了响应式的Websocket客户端API

### HandlerFunction
用来处理请求的处理逻辑
