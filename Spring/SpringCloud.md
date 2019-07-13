# Spring Cloud 学习笔记
Spring Cloud是分布式系统构建工具，具有负载均衡，容错保护，服务网关，消息总线等功能，可扩展性强，可以扩展多组件



# Eureka服务治理
主要功能：服务注册(每个服务单元向注册中心注册自己的ip，服务信息，端口等)，服务发现(客户端的发现机制，心跳监控(默认30秒)，客户端(Eureka Client)会缓存服务端(Eureka Server)的信息，所有如果Eureka Server宕机也可以有服务信息。

## 搭建服务注册中心

### 依赖包
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-eureka-server</artifactId>
    <version>1.4.5.RELEASE</version>
</dependency>

<dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>${spring-cloud.version}</version>
            <type>pom</type>
            <scope>import</scope>
</dependency>

```
- 在启动类配置

@EnableEurekaServer
```
SpringCLoud中的“Discovery Service”有多种实现，比如：eureka, consul, zookeeper。
1，@EnableDiscoveryClient注解是基于spring-cloud-commons依赖，并且在classpath中实现； 
2，@EnableEurekaClient注解是基于spring-cloud-netflix依赖，只能为eureka作用；
如果classpath中添加了eureka，则它们的作用是一样的。
```
- 在配置文件文件中

```yml
server:
    port: 1111 #服务注册中心的端口
eureka:
    instance:
        hostname: localhost
        prefer-ip-address: true #将IP注册到Eureka Server上，而如果不配置就是机器的主机名
    client:
        register-with-eureka: false #代表不向注册中心注册自己
        fetch-registry: false #设置不去检索服务     
        service-url:
            defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
```

## 创建服务提供者并注册
创建服务提供者并在服务中心进行注册

### 依赖包
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>2.0.4.RELEASE</version>
</dependency>

<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-eureka</artifactId>
    <version>1.4.5.RELEASE</version>
</dependency>

```

- 启动类加上注解
@EnableDiscoveryClient

- 配置
```
spring.application.name=hello-service #服务名字
eureka.client.service-url.defaultZone=http://localhost:1111/eureka/ #往服务中心上注册

```
## 高可用的注册中心
使用多节点的服务注册中心集群
- 在注册中心项目中配置

application-peer1.properties,application-peer2.properties两个配置文件使之通过--spring.profiles.actives指定运行配置使之成为两个服务中心节点

```
peer1:
spring.application.name=eureka-server
server.port=1111
eureka.instance.hostname=peer1
eureka.client.service-url.defaultZone=http://peer2:1112/eureka/
peer2:
spring.application.name=eureka-server
server.port=1111
eureka.instance.hostname=peer1
eureka.client.service-url.defaultZone=http://peer2:1112/eureka/

```
配置文件使之互相注册在注册中心中System32/driver/etc/hosts文件中写入
```
127.0.0.1 peer1
127.0.0.1 peer2
```

- 服务提供者配置

```
eureka.client.service-url.defaultZone=http://peer1:1111/eureka/,http://peer2:1112/eureka/

```
将服务注册到服务中心集群中,这个时候如果peer1服务器宕机了,依然可以在peer2服务器中
这里通过http://peer1:1111/eureka/ 定义地址,可以使用http://127.0.1:1111/eureka/ 即ip地址访问,这就要配置eureka.instance.perfer-ip-address=true来设置


### 关于Spring Boot的打包
对于有子模块的项目
- 主模块的pom.xml

```xml
 <packaging>pom</packaging>
```
- 子模块的pom.xml

自动生成的子模块的<parent>改为父模块,然后指定<relativePath>../pom.xml</relativePath>
<br>将<groupId><packaging>这些标签删去
```xml
  <parent>
        <groupId>com.xiong</groupId>
        <artifactId>springcloud</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <relativePath>../pom.xml</relativePath>
    </parent>
```
### 消费者(客户端)
使用Ribbon实现客户端的负载均衡

#### 依赖
```xml
<dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-ribbon</artifactId>
</dependency>   
```
#### 启动类中
注解@LoadBalanced开启负载均衡
<br>创建RestTemplate的Bean用来客户端消费者获取服务端的服务提供者
#### RestTemplate类
通过getForEntity()方法进行服务请求
### 服务容错保护:Spring Cloud Hystrix
能够保证在一个依赖出问题的情况下，不会导致整体服务失败，这个就是Hystrix需要做的事情。Hystrix提供了熔断、隔离、Fallback、cache、监控等功能，能够在一个、或多个依赖同时出现问题时保证系统依然可用。通过断路器的故障监控,当某个服务单元发生故障后,向调用方返回错误响应,避免长时间的等待。
#### 原理
![原理图](http://pcpj2g4mj.bkt.clouddn.com/18-8-15/91925440.jpg)
##### 1. HystrixCommand和HystrixObservableCommand
使用命令模式对请求进行封装成对象
- Receiver执行业务逻辑
- Command命令接口用来被具体的命令类进行继承
- ConcreteCommand具体的命令,成员为Receiver与命令
- Invoker调用者获取具体实现的命令并调用其中Receiver的业务逻辑

HystrixCommand和HystrixObservableCommand就是其中的ConcreteCommand,实现了具体的方法

- 设置超时时间

hystrix.command.default.execution.isolation.thread.timeoutInMilliseconds=(ms)

- 异步执行
```java
    @HystrixCommand
    public Future<User> getUserByIdAsync(final String id) {
        return new AsyncResult<User>() {
            @Override
            public User invoke() {
                return userResource.getUserById(id);
            }
        };
    }
```
## 重要配置
- eureka.instance.prefer-ip-address

配置eureka.instance.prefer-ip-address = true 就可以将IP注册到Eureka Server上，而如果不配置就是机器的主机名

----------------Feign声明式服务调用---------------------------
# Feign

## 概念
**为什么需要有feign？**
1) 动态ip

## 1. 功能介绍

服务消费端的调用框架，支持Hystrix容错保护和Ribbon负载均衡。

启动类注解@EnableFeignClients开启Feign

## 2. Robbin支持

Feign使的Robbin的实现只需声明即可,非常的优雅的配置
@FeignClient(name="服务名",fallback=fallback类.class)即可映射服务,绑定fallback

fallback类要实现service接口并注解@Component进行实例化

## 3. Hystrix支持

配置文件中使用设置feign.hystrix.enabled=true开启支持
- 写一个fallback类继承与服务接口
- 写一个服务接口,声明映射到对应的服务

@FeignClient(value = "hello-server",fallback = HelloServiceFallback.class)

### 3. 配置

#### 1. 请求压缩

feign请求响应压缩
<br>将超过阀值的请求进行GZIP压缩

```
feign.compression.request.enabled=true
feign.compression.response.enabled=true
feign.compression.request.mine-types=text/xml,application/xml,application/json
feign.compression.request.min-request-size=2048
```
#### 2. 日志配置
1. 配置开启日志
```
#feign日志配置
logging.level.com.xiong.springcloud.Api.Service.HelloService=DEBUG
```
2. 写配置类
```java
public class FeignClientConfiguration {
    @Bean
    Logger.Level feignLoggerLevel(){
        return Logger.Level.FULL;
    }
}
```
3. 对FeignClient指定配置类
  @FeignClient(configuration = FeignClientConfiguration.class)



# Zuul
- 服务网关，调用端并不是直接调用后端的服务，而是通过API网关根据URL请求通过路由到指定的服务
- 基于Ribbon的负载均衡

## 依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-zuul</artifactId>
    <version>2.0.1.RELEASE</version>
</dependency>
```
## 开启zuul
启动类注解@EnableZuulProxy(@EnableZuulClient的加强版，扩展Ribbon，Hytrix功能)
<br>默认添加(@EnableCircuitBreaker和@EnableDiscoveryClient)

## 配置
指定端口号并注册到服务中心

```yml
spring:
    application:
        name: GateWay
server:
    port: 8083

eureka:
    client:
        service-url:
            defaultZone: http://localhost:1111/eureka/

```
## 路由配置
微服务应用提供的接口,通过统一的API网关入口被客户端访问
### 路径匹配
使用Ant风格
- ?     匹配任意单个字符
- *     (单级目录)匹配任意数量的字符
- **    支持多级目录,匹配任意数量的字符


#### 不通过Eureka服务中心的路由配置

1. 单例

```yml
zuul:
    routes:
        自定义名字: 
            path: /demo/**
            url: http://www.baidu.com

# /demo/所有路径都会被转到www.baidu.com

```
2. 多例(负载均衡)

```yml
zuul:
    routes:
        api-a:
            path: /user-service/**
            serviceId: demo-service # 自定义的服务名，与Eureka无关
ribbon:
    eureka:
        enabled: false

demo-service:
    ribbon:
        listOfServers: http://localhost:8080/,http://localhost:8081/
# 会开启负载均衡对这个访问进行负载均衡
```

#### 面向服务的路由
```yml
zuul:
    routes:
        api-a:
            path: /user-service/**
            serviceId: demo-service # 与Eureka上注册的服务无关

```
这样配置之后可以通过网关以及映射的服务进行访问
```
http://localhost:8083/userservice/hello
```
#### 默认路由配置
默认使用http://localhost:8083/serviceId/** 进行访问

#### 忽略路由
```yml
zuul:
    ignored-patterns: /**/dev/**/
# 忽略包涵dev的请求
```
#### 复杂路由配置(通过正则表达式)
```java

import org.springframework.cloud.netflix.zuul.filters.discovery.PatternServiceRouteMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MyConfig {

    /**
     * 访问网关的 /invoker/**，将会被路由到 atm-zuul-invoker 服务进行处理
     * 
     * zuul:
     *  routes:
     *   myServer:
     *   path: /invoker/**
     *   serviceId: atm-zuul-invoker
     * 
     */
    @Bean
    public PatternServiceRouteMapper patternServiceRouteMapper() {
        // 通过一个正则表达式来匹配
        return new PatternServiceRouteMapper("(atm)-(zuul)-(?<module>.+)","${module}/**");
    }
}
```
### 请求过滤

[](https://blog.csdn.net/liuchuanhong1/article/details/62236793)

#### ZuulFilter类

实现ZuulFilter抽象类

```java
public class PreRequestLogFilter extends ZuulFilter {
    RequestContext rcx = RequestContext.getCurrentContext();
    HttpServletRequest hsr = rcx.getRequest(); //获得http请求
    /*
    pre：可以在请求被路由之前调用
    route：在路由请求时候被调用
    post：在route和error过滤器之后被调用
    error：处理请求时发生错误时被调用
    */
    @Override
    public String filterType() {
        return "pre";
    }
   
    @Override //定义执行顺序，数字越大，优先级越低
    public int filterOrder() {
    return 0;
    }
    
    @Override //判断该过滤器是否要执行，true表示执行，false表示不执行
    public boolean shouldFilter() {
    return true;
    }
    
    @Override //过滤器的具体逻辑
    public Object run() {
    return null;
    }
    /*
    RequestContext.setSendZuulResponse(false)表示对该请求拒绝路由
    RequestContext.setResponseStatusCode(401)设置放回代码
    */
}
```
#### 启用自定义过滤器
在启动类中创建过滤器Bean
```java
@Bean
public PreRequestLogFilter preRequestLogFilter() {
 return new PreRequestLogFilter();
}
```
#### 禁用过滤器
配置文件中
```
zuul.<SimpleClassName>.<filterType>.disable=true
```
### 动态加载
在不关闭或重启的情况下实现修改路由规则，添加修改过滤器

# Config配置中心
集中管理各个环境的配置

## server端 以接口的方式提供配置

### 依赖

```
<dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-config-server</artifactId>
</dependency>
```
## 在github上创建配置文件
## 配置文件
```
server:
  port: 8040
spring:
  application:
    name: config-server
  cloud:
    config:
      server:
        git:
          uri: https://github.com/ityouknow/spring-cloud-starter   # 配置git仓库的地址
          search-paths: config-repo        # git仓库地址下的相对地址，可以配置多个，用,分割。
        #  username:                        # git仓库的账号
        #  password:                        # git仓库的密码
```
## 启动
```
启动类@EnableConfigServer注解
```
仓库中的配置文件会被转换成web接口，访问可以参照以下的规则：
```
/{application}/{profile}[/{label}]
/{application}-{profile}.yml
/{label}/{application}-{profile}.yml
/{application}-{profile}.properties
/{label}/{application}-{profile}.properties
```
- client端 通过接口获取配置

## 依赖
```
<dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-config</artifactId>
</dependency>
```
## 配置

### bootstrap配置
<br>在项目启动过程中被读取
```yml
spring:
  cloud:
      config:
        label: master
        uri: http://localhost:10000/
        profile: dev
        enabled: true
        discovery:
          service-id: config-server

```

### application配置
按需配置
```yml

```
## 

# 链路跟踪Sleuth
记录服务间的调用，调用时间，状态等
- Span: 一个总的远程调用下一系列跨度 
- Trace: 一个总的远程调用跨度
  服务调用者为client
- server sent
- client receive
- server receive
- client sent
  cs与cr为一个span: 一个服务请求到结果返回的记录
  <br>sr与ss为一个span: 一个服务处理时间

# zipkin(Sleuth数据收集与可视化)
## 服务端
### 依赖
2.10.1版本出现问题
```xml
 <dependency>
    <groupId>io.zipkin.java</groupId>
    <artifactId>zipkin-server</artifactId>
    <version>2.9.4</version>
</dependency>
<dependency>
    <groupId>io.zipkin.java</groupId>
    <artifactId>zipkin-autoconfigure-ui</artifactId>
    <version>2.9.4</version>
</dependency>
<dependency>
    <groupId>io.zipkin.java</groupId>
    <artifactId>zipkin-autoconfigure-storage-mysql</artifactId>
    <version>2.9.4</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>

```

### 启动类
```java

package com.xiong.zipkinserver;

import javax.sql.DataSource;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.context.annotation.Bean;
import zipkin.server.internal.EnableZipkinServer;
import zipkin2.storage.mysql.v1.MySQLStorage;

@EnableZipkinServer
@EnableEurekaClient
@SpringBootApplication
public class ZipkinServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(ZipkinServerApplication.class, args);
    }

    @Bean
    public MySQLStorage mySQLStorage(DataSource datasource) {
        return MySQLStorage.newBuilder().datasource(datasource).executor(Runnable::run).build();
    }
}

```
## 客户端
### 依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-zipkin</artifactId>
    <version>2.0.2.RELEASE</version>
</dependency>

```
### 配置
```yml
spring:
    zipkin:
        baseUrl: http://localhost:11008 # zipkin server 地址
    sleuth:
    sampler:
      probability: 1 # 采集比例
```

---via MQ + elasticsearch---
最新版的zipkin中@EnableZipkinStreamServer不被推荐使用，所有使用官方的docker镜像

## 服务端
### Elasticsearch
```s
docker run -it  -p 9200:9200 -p 9300:9300 -v /opt/data/elasticsearch/logs:/usr/share/elasticsearch/logs -v /opt/data/elasticsearch/data:/usr/share/elasticsearch/data --name mylasticsearch -e "discovery.type=single-node" elasticsearch:6.4.2

docker run -it  -p 9200:9200 -p 9300:9300 -d --name mylasticsearch -e "discovery.type=single-node" elasticsearch:6.4.2


```

### Docker

```s
# rabbitmq+mysql
docker run --name zipkin-server-rabbitmq-mysql -e RABBIT_ADDRESSES=192.168.88.129:5672 -e RABBIT_PASSWORD=root -e RABBIT_USER=user -e STORAGE_TYPE=mysql -e MYSQL_HOST=192.168.99.100 -e MYSQL_USER=root -e MYSQL_PASS=root -d -p 9411:9411 openzipkin/zipkin


# rabbitmq+elasticsearch

docker run --name zipkin-server-rabbitmq-ela1 -e RABBIT_ADDRESSES=192.168.88.129:5672 -e RABBIT_PASSWORD=root -e RABBIT_USER=user -e STORAGE_TYPE=elasticsearch -e ES_HOSTS=192.168.88.129 -d -p 9411:9411 openzipkin/zipkin

docker run --name zipkin-dependences -e STORAGE_TYPE=elasticsearch -e ES_HOSTS=192.168.88.129 -d  openzipkin/zipkin-dependencies

# 因为使用elasticsearch需要zipkin-dependency容器来show dependency


```
## 客户端
### 依赖
```xml

 <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-zipkin</artifactId>
    <version>2.0.2.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-stream-binder-rabbit</artifactId>
    <version>2.0.1.RELEASE</version>
</dependency>

```
### 配置文件

```yml
rabbitmq: 
    host: 192.168.88.129
    port: 5672
    username: user
    userpass: root
```
# Spring Cloud Gateway



# 功能
- 基于 Spring Framework 5，Project Reactor 和 Spring Boot 2.0 动态路由
- 限流
- 集成 Hystrix 断路器
- Predicates 和 Filters 作用于特定路由

# 原理(组件)



## GatewayHandlerMapping(路由匹配组件)
通过Preticate条件来选择路由规则(可能匹配到多个路由，通过Order和加载顺序排序，从上到下匹配第一个，"/actuator/gateway/routes"可以看到所有按顺序排列的routes)。使用RouteLocator获取Route


## RouteDefinitionLocator(路由定义加载器)
负责获取路由配置，生成RouteDefinition



**RouteDefinitionLocator**的子类实现类:

1. CachingRouteDefinitionLocator 

RouteDefinitionLocator包装类， 缓存目标RouteDefinitionLocator 为routeDefinitions提供缓存功能，已经被 CachingRouteLocator 取代。

2. CompositeRouteDefinitionLocator 

-RouteDefinitionLocator包装类，组合多种 RouteDefinitionLocator 的实现，**最终**为 routeDefinitions提供统一入口

3. PropertiesRouteDefinitionLocator

从配置文件(GatewayProperties例如，YML/Properties等)读取RouteDefinition。这也就是常用的在application.yml里配置路由规则的静态路由方式。

4. DiscoveryClientRouteDefinitionLocator

从注册中心(例如，Eureka/Consul/Zookeeper/Etcd等)读取RouteDefinition。也就是基于服务发现的路由，DiscoveryClientRouteDefinitionLocator通过org.springframework.cloud.client.discovery.DiscoveryClient来获取注册在注册中心的服务列表，生成对应的RouteDefinition数组。

5. RouteDefinitionRepository

从存储器(例如，内存/Redis/MySQL等)读取RouteDefinition，这也是实现动态路由的关键接口，通过实现RouteDefinitionRepository接口自定义RouteDefinitionRepository类获取RouteDefinition。

## RouteLocator(路由加载器)

RouteDefinitionLocator(路由定义加载器)获取RouteDefinition(路由定义)后，GatewayHandlerMapping使用RouteLocator(路由加载器)将RouteDefinition(路由定义)生成Route(路由规则)。

- CompositeRouteLocator
统一路由加载器，为RoutePredicateHandlerMapping 提供统一入口访问路由。

- CachingRouteLocator
用来缓存路由的RouteLocator实现类，RoutePredicateHandlerMapping调用CachingRouteLocator的RouteLocator#getRoutes()来获取Route。提供事件( org.springframework.context.ApplicationEvent.RefreshRoutesEvent事件)监听方法，刷新路由缓存

## WebHandler(过滤器处理组件)
通过创建请求对应的Route的GatewayFilterChain进行请求处理
1. 通过HandlerMappin组件的生成的Route获取Filters，
2. 全局过滤器适配(GatewayFilterAdapter)成GatewayFilter并添加到每个路由的过滤器数组中(ArrayList)
3. 返回生成的过滤器链表

### WebHandler#handle()分析

```java
@Override
public Mono<Void> handle(ServerWebExchange exchange) {
 	    // 获得 Route
 		Route route = exchange.getRequiredAttribute(GATEWAY_ROUTE_ATTR);
 		
         // 获得 GatewayFilter
 		List<GatewayFilter> gatewayFilters = route.getFilters();
 		List<GatewayFilter> combined = new ArrayList<>(this.globalFilters);
 		combined.addAll(gatewayFilters);

 		// 根据Orderd排序
		AnnotationAwareOrderComparator.sort(combined);
 		logger.debug("Sorted gatewayFilterFactories: "+ combined);
 
 		// 创建 DefaultGatewayFilterChain
 		return new DefaultGatewayFilterChain(combined).filter(exchange);
 	}
```


## 路由
- id
- 目标地址URI
- 一组路由先决条件(Perdicate)
- 一组路由过滤器

## 依赖包
不可以包涵spring-boot-starter-web包，是使用spring-boot-starter-webflux异步非阻塞基于响应式流
```xml
 <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-gateway</artifactId>
    <version>2.0.2.RELEASE</version>    
</dependency>
```

## Perdicate
路由的先决条件，可以有多个perdicate，他们的以逻辑AND共同作用。匹配是否满足过此路由规则的条件。
<br>官方给出以下的Perdicate，使用的时候在配置文件中或是config类中对应格式指定。

- After Route Predicate Factory

这个时间之后则进行路由，1个参数:datetime 
```
- After=2017-01-20T17:42:47.789-07:00[America/Denver]
```

- Before Route Predicate Factory

这个时间之前则进行路由，1个参数:datetime 
```
- Before=2017-01-20T17:42:47.789-07:00[America/Denver]

```

- Between Route Predicate Factory

这个时间之内 2个参数:datetime1,datetime2
```
- Between=2017-01-20T17:42:47.789-07:00[America/Denver], 2017-01-21T17:42:47.789-07:00[America/Denver]
```

- Cookie Route Predicate Factory

带有这个cookie 2个参数:name,regular expression(正则表达式)
```
- Cookie=chocolate, ch.p

```
- Header Route Predicate Factory

带有这个header 2个参数:name,regular expression(正则表达式)
```
- Header=chocolate, ch.p

```

- Host Route Predicate Factory

对该host的请求进行路由 1个参数:pattern(Ant风格的模式)
```
- Host=**.somehost.org
```

- Method Route Predicate Factory

对请求方法进行判断 1个参数:HTTP method
```
- Method=GET
```


- Path Route Predicate Factory

对请求路径进行路由 1个参数:(Ant风格)路径匹配模式 PathMatcher pattern
```
- Path=/foo/{segment}
```

- Query Route Predicate Factory

对请求有该参数进行路由判断 1个参数:param
```
- Query=baz
```
<br>对请求有该参数即该值进行路由 2个参数:param,regexp
```
- Query=baz,foo*
```

- RemoteAddr Route Predicate Factory
对某网段的远程地址的请求进行路由(也可以是一个远程地址) 1个参数:CIDR-notation (IPv4 or IPv6) strings
```
- RemoteAddr=192.168.1.1/24
```
使用这个路由断言的如果在网关之前有代理层，是无法获取正确的客户端ip的，需要使用 XForwardedRemoteAddressResolver.maxTrustedIndex(index);获取真实的客户端ip(X-Forwarded-For请求头参数)


## 过滤器
在http请求进入出去网关的时候修改请求
### 官方自带过滤器

[官方过滤器](http://cloud.spring.io/spring-cloud-gateway/single/spring-cloud-gateway.html#_addrequestheader_gatewayfilter_factory)
- 增加请求头过滤器
- 增加请求参数过滤器
- 增加响应参数过滤器
- 熔断过滤器

默认集成了Hystrix熔断机制
```yml
- Hystrix=myCommandName #熔断命令
```
也这样设置
```yml
- name: Hystrix
    args:
        name: fallbackcmd
        fallbackUri: forward:/incaseoffailureusethis # 发生将请求发送到 /incaseoffailureusethis controller
```

- 添加前缀过滤器
- PreserveHostHeader GatewayFilter Factory

PreserveHostHeaderGatewayFilter就是在gateway转发请求的时候把原始请求的host头部带上，转发给目标服务。默认该filter是启用的

- 限速过滤器
Redis+Lua技术实现，令牌桶限流方案。
![令牌桶算法](http://pcpj2g4mj.bkt.clouddn.com/18-11-14/76193165.jpg)
1. 存放固定容量令牌的桶，按照固定速率往桶里添加令牌
2.

- 重定向过滤器

- 删除代理头过滤器？

- 删除请求头过滤器

- 删除响应头过滤器

- 重写请求路径过滤器

- 保存session过滤器

- 重试过滤器



### GatewayFilter
网关过滤器接口，有且只有一个方法filter，执行当前过滤器，并在此方法中决定过滤器链表是否继续往下执行。需要通过spring.cloud.routes.filters 配置在具体路由下
<br>实现GatewayFilter的方式
- 继承AbstractGatewayFilterFactory抽象类
使用@Component注解声明Bean，然后与官方自带过滤器配置使用方式一样，

- 实现GatewayFilter(,Ordered)接口


### GlobalFilter
<br>为请求业务以及路由的URI转换为真实业务服务的请求地址的核心过滤器，不需要配置，模式系统初始化时加载，并作用在每个路由上。GlobalFilter转换成GatewayFilter，并作用于每个路由上，在FilteringWebHandler实现

### GatewayFilterChain
网关过滤链表接口，用于过滤器的链式调用，
过滤器链表接口的默认实现**DefaultGatewayFilterChain**
<br>包含2个构建函数：
<br>    1. 集合参数构建用于初始化吧构建链表
<br>    2. index，parent参数用于构建当前执行过滤对应的下次执行的链表 

#### 过滤器的GatewayFilterChain 执行顺序
1. 通过GatewayFilter集合构建顶层的GatewayFilterChain
2. 调用顶层GatewayFilterChain，获取第一个Filter，并创建下一个Filter索引对应的GatewayFilterChain
3. 调用filter的filter方法执行当前filter，并将下次要执行的filter对应GatewayFilterChain传入。


## 静态路由
配置在配置文件或是配置bean中
```yml

spring:
    cloud:
        gateway:
            enabled: false # 关闭gateway，默认开启
---
spring:
  cloud:
    gateway:
      discovery:
        locator:
          enabled: true  # 是否与服务发现组件进行结合
      routes:
      - id: host_route          
        uri: https://baidu.com/         # 通过url路径路由
        predicates:                     # 路由条件
        - Path=/baidu/**                    # 通过访问路径路由
        filters:                        # 过滤  
        - StripPrefix=1                     # 去掉前面一个前缀
      - id: server_route                # id
        uri: lb://DEMO-SERVER           # 通过服务名 lb://大小ServiceId
        predicates:                     # 路由条件
        - Path=/demo/**
        filters:                        # 过滤器
        - StripPrefix=1
```
# 动态路由
在不用重启项目的情况下动态刷新路由信息(缓存在CachingRouteLocatar)
## 实现自定义的RouteDefinitionRepository类

### 发起RefreshRoutesEvent的事件
cache会监听该事件，并重新拉取路由配置信息

# Gateway初始化
## 四个配置类


- GatewayClassPathWarningAutoConfiguration

用来检查是否错误的引入了web依赖包，并且检查webflux依赖的正确性


- GatewayLoadBalancerClientAutoConfiguration

为以服务ID方式的路由规则进行负载均衡

- GatewayRedisAutoConfiguration

因为限流功能是基于Redis+Lua实现桶令牌限流算法，所有这个配置是初始化 RedisRateLimiter

- GatewayAutoConfiguration

对如下的类进行初始化
```
    - NettyConfiguration
    - GlobalFilter
    - FilteringWebHandler
    - GatewayProperties
    - PrefixPathGatewayFilterFactory
    - RoutePredicateFactory
    - RouteDefinitionLocator
    - RouteLocator
    - RoutePredicateHandlerMapping
    - GatewayWebfluxEndpoint
```
















# Spring Cloud Docker部署
