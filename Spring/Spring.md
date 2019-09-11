# Spring学习笔记

# 概念以及核心模块

Spring原理上核心作用个人理解概括为两点，IOC(控制反转)和AOP(面向切面)。而更加核心的是IOC。提供一种框架用于开发中解决依赖问题，简化开发。
![spring核心模块](https://img-blog.csdn.net/20151106085054858)

## 核心容器(Spring core)
核心容器提供Spring框架的基本功能。Spring以bean的方式组织和管理Java应用中的各个组件及其关系。Spring使用BeanFactory来产生和管理Bean，它是工厂模式的实现。BeanFactory使用控制反转(IoC)模式将应用的配置和依赖性规范与实际的应用程序代码分开。BeanFactory使用依赖注入的方式提供给组件依赖。
内核容器是由spring-core、spring-beans、spring-context、spring-context-support和spring-expression（Spring Expression Language）模块组成。 
<br>Spring-core和spring-beans模块提供了框架的基本功能，包括IoC和依赖注入特性。BeanFactory是工场模式的精美实现。它不需要单独的编程逻辑就可以把所依赖的配置和规范从程序的实际逻辑中分离开。 
Context（spring-context）模块是在Core和Beans模块的基础之上构建的，它是一种类似于JNDI注册的访问框架样式内的对象的方法。Context模块继承了Beans模块的特性，并添加了国际化（使用资源绑定的方式）、事件传播、资源加载、以及通过Servlet容器透明创建的上下文环境。Context模块也支持Java EE特性，如EJB、JMX和基本的远程调用。ApplicationContext接口是Context模块的入口。spring-context-support提供了把常用的第三方类库（如缓存（EhCache、Guava、JCache）、邮件（JavaMail）、计划（CommonJ、Quartz）、以及模板引擎（FreeMarker、JasperReports、Velocity））集成到Spring应用场景中的支持。 
spring-expression模块提供了可用于运行时查询和操作对象的强大的表达式语言。它是JSP2.1规范中指定的统一表达式语言的一个扩展。它支持设置和获取属性值、属性匹配、方法调用、访问数组内容、集合和索引、逻辑和算术运算、命名变量、以及使用对象名从Spring容器中检索对象等功能。它还支持列表的投射和选择以及常用的列表聚合。能。
<br>Spring的核心是Context，Core，Bean。Core实现了IOC功能，Content使用Core工具来维护Bean之间的关系。

## Context(上下文)

## Spring面向切面编程(Spring AOP)
通过配置管理特性，Spring AOP 模块直接将面向方面的编程功能集成到了 Spring框架中。所以，可以很容易地使 Spring框架管理的任何对象支持 AOP。Spring AOP 模块为基于 Spring 的应用程序中的对象提供了事务管理服务。通过使用 Spring AOP，不用依赖 EJB 组件，就可以将声明性事务管理集成到应用程序中。


## Spring DAO模块
DAO模式主要目的是将持久层相关问题与一般的的业务规则和工作流隔离开来。Spring 中的DAO提供一致的方式访问数据库，不管采用何种持久化技术，Spring都提供一直的编程模型。Spring还对不同的持久层技术提供一致的DAO方式的异常层次结构。比如Mybatis中Mapper接口

## Spring ORM模块
Spring 与所有的主要的ORM映射框架都集成的很好，包括Hibernate、JDO实现、TopLink和IBatis SQL Map等。Spring为所有的这些框架提供了模板之类的辅助类，达成了一致的编程风格。

## Spring Web模块
Web上下文模块建立在应用程序上下文模块之上，为基于Web的应用程序提供了上下文。Web层使用Web层框架，可选的，可以是Spring自己的MVC框架，或者提供的Web框架，如Struts、Webwork、tapestry和jsf。

## Spring MVC框架(Spring WebMVC)
MVC框架是一个全功能的构建Web应用程序的MVC实现。通过策略接口，MVC框架变成为高度可配置的。Spring的MVC框架提供清晰的角色划分：控制器、验证器、命令对象、表单对象和模型对象、分发器、处理器映射和视图解析器。Spring支持多种视图技术。  


# Ioc/DI

控制反转/依赖注入，将类的实例化，依赖关系(A has B关系)，通过配置文件交予容器，让容器进行依赖注入
<br>我的理解是容器就是一个工厂,而工厂的信息就通过配置文件获取从而得到一个bean

## 容器

- BeanFactory接口

Spring容器最基本的接口就是BeanFactory，给 DI 提供了基本的支持，它用 org.springframework.beans.factory.BeanFactory 接口来定义，延迟加载所有的Bean，为了从BeanhFactory得到一个Bean,只要调用getBean()方法，就能获得Bean。BeanFactory的子接口ApplicationContext，因此也称之为Spring上下文。
```java

Boolean containBean(String name)    //判断Spring容器是否包含id为name的Bean实例。

<T> getBean(Class<T> requiredTypr)  //获取Spring容器中属于requiredType类型的唯一的Bean实例。

Object getBean(String name)         //返回Sprin容器中id为name的Bean实例。

<T> T getBean(String name,Class requiredType)   //返回容器中id为name,并且类型为requiredType的Bean

Class <?> getType(String name)      //返回容器中指定Bean实例的类型。
```
**BeanFactory的实现类**
<br>一般都是使用这个实现类：org.springframework.beans.factory.xml.XmlBeanFactory
<br>从xml文件中读取Bean，在Spring3.1之后就被遗弃了，一般使用BeanFactory的字接口ApplicationContext的实现类ClassPathXmlApplicationContext来获取xml中的Bean配置。


- ApplicationContext接口
是BeanFactory的子接口，拥有BeanFactory所有功能，并增加了其他功能，ApplicationContext会将配置文件中的Bean全部加载初始化，所有占用的内存比较大。该容器添加了更多的企业特定的功能，例如从一个属性文件中**解析文本信息的能力**，发布应用程序事件给感兴趣的**事件监听器的能力**。

```
ApplicationContext接口的实现类 :
    - FileSystemXmlApplicationContext :  从完整路径获取xml配置文件
    - ClassPathXmlApplicationContext :   通过source文件下查找从applicationContext.xml配置文件
    - AnnotationConfigApplicationContext: 从一个或多个基于java的配置类中加载上下文定义，适用于java注解的方式
    - XmlWebApplicationContext :         会在一个 web 应用程序(servlet容器)的范围内加载
```
<br>获取配置文件进行对象初始化和注入
<br>通过getBean()获取对象。

## Bean
类的实例化，具有唯一id。它相对于一个实例化对象。
### Bean的实例化
Bean**实例化**还需要进行**依赖注入**，有四种实例化方法：

**1. setter方法**
<br>类中的成员变量需要有Setter方法，这种方式的原理是使用反射获取setter方法进行赋值源码如下
```java
Method setter = properdesc.getWriteMethod();//获取属性的setter方法 ,private
if(setter!=null){
    Object value = sigletons.get(propertyDefinition.getRef());
    setter.setAccessible(true);
    setter.invoke(bean, value);//把引用对象注入到属性
}
```
<br>使用方法(基础类型或String类或包装类):

```xml
<!--使用无参构造方法实例化-->
<bean name="car" class="com.xiong.Car"/>

<!--有参构造方法实例化-->
<bean name="user_1" class="com.xiong.User">
    <property name="drive" ref="car" />  
    <!--或者-->
    <property name="drive"><bean id="car" class="com.xiong.Car"/></property>
</bean>   

```

<br> 对集合属性的注入:
```xml
 <bean id="user" class="com.xiong.User">
      <property name="addressList">
         <list>
            <value>INDIA</value>
            <value>Pakistan</value>
            <value>USA</value>
            <value>USA</value>
         </list>
      </property>
      <property name="addressSet">
         <set>
            <value>INDIA</value>
            <value>Pakistan</value>
            <value>USA</value>
        </set>
      </property>

      <property name="addressMap">
         <map>
            <entry key="1" value="INDIA"/>
            <entry key="2" value="Pakistan"/>
            <entry key="3" value="USA"/>
            <entry key="4" value="USA"/>
         </map>
      </property>
      <!-- results in a setAddressProp(java.util.Properties) call -->
      <property name="addressProp">
         <props>
            <prop key="one">INDIA</prop>
            <prop key="two">Pakistan</prop>
            <prop key="three">USA</prop>
            <prop key="four">USA</prop>
         </props>
      </property>

   </bean>
```

**2. 构造函数**
<br>其实上面的例子中就是使用无参构造方法进行实例化，接下里介绍一下有参构造方法
```xml
<bean name="user_1" class="com.xiong.User">  
        <!--有带参的构造方法,按参数顺序-->  
        <constructor-arg ref="car"></constructor-arg>  
        <constructor-arg value="Songxiong Lin"></constructor-arg>  
</bean>  
<bean name="car" class="com.xiong.Car"></bean>  

```

**3. 静态工厂**
使用工厂的静态方法返回Bean
```java
public class UserFactory {  
    //静态工厂  
    public static final User getUserInstance(String name){  
        return new User(name);  
    }  
}  
```

```xml
<!--class指向工厂类，并指定factory-method为静态方法-->
<bean id= "user_1" class ="com.xiong.UserFactory"  factory-method= "getUserInstance">
</bean>

```


**4. 实例工厂**
```java
public class UserFactory {  
  
    public User getUserInstance(String name){  
        return new User(name);  
    }  
}  
```

```xml
<!--工厂类实例-->
<bean id ="userFactory" class = "com.xiong.UserFactory">
    <property name="name" value="Xiong Lin" />
</bean>

<!--factory-bean为工厂类的bean，并指定返回实例的方法-->
<bean id= "user_1"  factory-bean ="userFactory"  factory-method= "getUserInstance">  
</bean>
```

### xml配置中的Bean属性
```xml
<bean id = "bean的唯一表示" name="" class ="类" scope="指定作用域">
    <property name="类的属性名" value="基础类型或包装类以及String的值" />
    <property name="类的属性名" ref="属性依赖的注入的bean" />
    
</bean>

```
- id    bean的唯一标识符
- class	指定用来创建bean的类。
- name	指定的bean标识符。在基于XML的配置元数据中，可使用ID和/或name属性来指定 bean 标识符。
- scope	指定由特定的 bean 定义创建的对象的作用域
    - singleton 属性默认值，默认值在spring IoC容器仅存在一个Bean实例，Bean以单例方式存在，既在容器内共享一个对象
    - prototype	每次从容器中调用Bean时，都返回一个<strong>新的实例</strong>
    - request   每次HTTP请求都会创建一个新的Bean，该作用域仅适用于WebApplicationContext环境
    - session	同一个HTTP Session共享一个Bean，不同Session使用不同的Bean，仅适用于WebApplicationContext环境
    - global-session	一般用于Portlet应用环境，改作用于仅适用于WebApplicationContext环境
- constructor-arg	使用构造方法来注入依赖关系
- properties	通过设值方法注入依赖关系的
- autowiring 	指定通过"byName"或是"byType"方式来注入依赖关系的
- lazy-initialization 懒加载，延迟初始化的 bean 告诉 IoC 容器(BeanFactory容器都是lazy-)在它第一次被请求时，而不是在启动时去创建一个 bean 实例。
- initialization 方法在 bean 的所有必需的属性被容器设置之后，调用回调方法的容器被销毁时，使用回调方法。

### Bean的生命周期
Bean的完整生命周期经历了各种方法调用，这些方法可以划分为以下几类：
- Bean自身的方法　　：　　这个包括了Bean本身调用的方法和通过配置文件中<bean>的init-method和destroy-method指定的方法
- Bean级生命周期接口方法　　：　　这个包括了BeanNameAware、BeanFactoryAware、InitializingBean和DiposableBean这些接口的方法
- 容器级生命周期接口方法　　：　　这个包括了InstantiationAwareBeanPostProcessor 和 BeanPostProcessor 这两个接口实现，一般称它们的实现类为“后处理器”。
- 工厂后处理器接口方法　　：　　这个包括了AspectJWeavingEnabler, ConfigurationClassPostProcessor, CustomAutowireConfigurer等等非常有用的工厂后处理器　　接口的方法。工厂后处理器也是容器级的。在应用上下文装配配置文件之后立即调用。

具体流程:

- 容器启动

```
1.  实例化bean对象
2.  如果实现接口，则调用BeanNameAware的setBeanName方法。Bean获取自己在BeanFactory配置中的名字(根据情况是id或者name或是默认的类名)
3.  如果实现接口，则调用BeanFactoryAware的setBeanFactory方法。传入该Bean的BeanFactory，这样该Bean就获得了自己所在的BeanFactory
4.  如果实现接口调用ApplicationContextAware的setApplicationContext方法。传入该Bean的ApplicationContext，这样该Bean就获得了自己所在的ApplicationContext
5.  调用BeanPostProcess的postProcessBeforeInitialization方法。对上下文中的所有Bean初始化之前执行该方法
6.  调用InitializingBean的afterPropertiesSet方法。初始化bean开始时(init-method之前)都会执行该方法，相对于init-method，效率更高，但是代码对Spring依赖
7.  调用自定义的init-method()初始化方法。InitializingBean的afterPropertiesSet方法之后。因为是通过反射的方式，所以效率比afterPropertiesSet第，但是对Spring依赖小一些。
8.  调用BeanPostProcess的postProcessAfterInitialization方法。在初始化完成之后。
9.  Bean准备就绪
// 
BeanPostProcess.postProcessBeforeInitialization()
    InitializingBean.afterPropertiesSet()
    init-method()
BeanPostProcess.postProcessAfterInitialization() 
```
- 对于singleton单例交由容器管理，对于prototype交由客户端处理
- 容器关闭

```
1. 调用DispostbleBean的destroy方法
2. 调用自定义的destroy-method()销毁方法

//
DispostbleBean.destroy()
   destroy-method()
```

#### Bean后置处理器
Bean的生命周期中有BeanPostProcessor接口，这个接口的实现类的实例化Bean注册到容器中后，所在的容器的**所有bean**的初始化前后分别执行指定的重写的方法。这个两个方法有返回值，如果没返回值会出现NoullPoint异常，因为，返回的bean会被重新返回容器中。

```java
public class PostProcessor implements BeanPostProcessor {  

    //在初始化之前执行
    @Override  
    public Object postProcessBeforeInitialization(Object bean, String beanName)throws BeansException {  
        System.out.println("对象" + beanName + "开始初始化");  
        return bean; //返回的bean才能重新放回容器中
    } 

    //在初始化完成之后执行 
    @Override  
    public Object postProcessAfterInitialization(Object bean, String beanName)throws BeansException {  
        System.out.println("对象" + beanName + "初始化完成");  
        return bean;  //返回的bean才能重新放回容器中
    }  
}  
```

并写bean，spring会自动识别这个类的bean
### Bean的继承
Bean的继承和类的继承不同,Bean的继承是对父Bean属性的继承。
- 继承的属性可以重写
- 可以设置抽象bean的abstract="true"，使之成为抽象bean，不可被实例化。

## Bean的自动装配
使得Bean的注入不需要通过显示地注入bean
- autowire="byName" 通过依赖bean的id或是name与**属性对象名**自动装配
- autowire="byType" 根据**属性的数据类型**自动装配，有多满足的bean，会报异常
- autowire="constructor" 通过有参构造方法的**参数类型**匹配。如果一个不匹配，或是多匹配都会出错。
- autowire="autodetec" 首先constructor，如果不执行，则ByTypec

对于同多个满足条件的bean会根据
- 是否带有Primary注解
- 是否优先级最高
- 是否属性Name与bean的id相对应
<br>如果没有找到最佳项则抛出异常

# 配置方式
有三种配置:

1. 基于XML配置
2. 基于注解配置
3. 基于java配置

## 基于XML配置
```xml
<context:annotation-config/>
<!--作用是显式地向Spring容器注册
AutowiredAnnotationBeanPostProcessor、
CommonAnnotationBeanPostProcessor、
PersistenceAnnotationBeanPostProcessor 
以及 RequiredAnnotationBeanPostProcessor 这4个BeanPostProcessor。注册这4个 BeanPostProcessor的作用，能够识别相应的注解-->

```
## 基于注解配置
<br>**Bean定义**: 在Bean的实现类上使用@Component注解或是衍生注解(@Controller,@Service,@Repository)来定义Bean。

<br>**Bean命名**: 使用@Component("BeanName")定义Bean名，默认使用类名第一个字母小写命名。

<br>**@Autowired注入**: 使用@Autowired进行注入，首先在容器中查询**对应类型**的bean,
1. 如果查询结果刚好为一个，将其注入。
2. 如果查询的结果不止一个，那么@Autowired会根据名称来查找。
3. 如果**查询的结果为空，那么会抛出异常**。解决方法时，使用required=false。

<br>**@Resource注入**:@Resource也可以使用@Resource (import javax.annotation.Resource) 进行注入。Spring将@Resource注解的name属性解析为bean的名字，而type属性则解析为bean的类型。
@Resource装配顺序

1. 如果同时指定了name和type，则从Spring上下文中找到唯一匹配的bean进行装配，找不到则抛出异常
2. 如果指定了name，则从上下文中查找名称（id）匹配的bean进行装配，找不到则抛出异常
3. 如果指定了type，则从上下文中找到类型匹配的唯一bean进行装配，找不到或者找到多个，都会抛出异常
4. 如果既没有指定name，又没有指定type，则自动按照byName方式进行装配；如果没有匹配，则回退为一个原始类型进行匹配，如果匹配则自动装配；

使用@Resource是使用J2EE，进行注入不需要使用setter方法。

## 基于java配置


# 事件监听
## 5个标准的事件：
- 上下文更新事件(ContextRefreshedEvent):
该事件会在ApplicationContext被初始化或者更新时发布。也可以在调用ConfigurableApplicationContext(ApplicationContext的子接口)接口中的refresh()方法时被触发。

- 上下文开始事件(ContextStartedEvent):
当容器调用ConfigurableApplicationContext的Start()方法开始/重启容器时触发该事件。

- 上下文停止事件(ContextStoppedEvent):
当容器调用ConfigurableApplicationContext的Stop()方法停止容器时触发该事件。

- 上下文关闭事件(ContextClosedEvent):
当ApplicationContext被关闭时触发该事件。容器被关闭时，其管理的所有单例Bean都被销毁。

- 请求处理事件(RequestHandledEvent):
在Web应用中，只能应用于使用DispatcherServlet的Web应用。在使用Spring作为前端的MVC控制器时，当Spring处理用户请求结束后，系统会自动触发该事件。

## 实现
### 监听器(Listener)
通过实现ApplicationListener接口，并将其**注册入容器**进行事件监听，
```java
public class MyListener implements ApplicationListener{
    @Overried
　　 public void onApplicationEvent(ApplicationEvent event) 
    {
        //事件类型
　　　　if (event instanceof ContextStartedEvent) 
        {
             System.out.println("开始执行");
        } else if (event instanceof ContextClosedEvent) 
            {
            System.out.println("结束执行");
            }else if (event instanceof ContextRefreshedEvent) 
                {
                System.out.println("刷新事件");
                }
　　 }
}
```
## 自定义事件
自定义事件与标准事件类似,只不过需要将自定义事件绑定监听器,还需要自己实现发布者
<br>过程如下
<br>1. 通过继承ApplicationEvent类自定义事件类
<br>2. 实现ApplicationListener接口的事件监听类并绑定事件(好像是在xml配置文件中写入bean,spring就会自己调用监听器监听事件)

```java
public class MyEventListener implements ApplicationListener<MyEvent>{
    @Override
    public void onApplicationEvent(MyEvent myevent) {
        MyEvent event = myevent;
    }
}
```
### 事件(Event)
继承自ApplicationEvent，需要调用父类的ApplicationEvent(Object source)构造方法，用来指定发布者。
```java
public class MyEvent extends ApplicationEvent {
    public MyEvent(Object source) 
    {
        //父类构造方法
        super(source);
    }
    private static final long serialVersionUID = 1L;

}
```

### 发布者
继承ApplicationContextAware接口，该Bean可以获得容器的引用，将其**注册入容器**然后就可以进行事件发布。其实发布者还是ApplicationContext容器。
```java

public class Publisher implements ApplicationContextAware{
    
    private ApplicationContext applicationContext;
    public void publish(){
        //必须通过ApplicationContext发布事件
        applicationContext.publishEvent(new AnimalSpeakEvent(ac));
    }
    @Override
    public void setApplicationContext(ApplicationContext arg0)
            throws BeansException {
          this.ac = arg0;       
    }
}
```

# AOP
AOP既面向切面的编程,既在设置横切关注点，在该关注点设置执行前，执行后，执行插入的功能，比如日志，缓存等功能
- 静态代理
    在编译阶段生成代理类，会在编译阶段将Aspect织入Java字节码
- 动态代理(Spring AOP使用的方式)
    在运行阶段，字节码写入内存是使用反射技术对被代理类进行切入。

## 使用代码生成代理类实现
即自己生成代理类。代理类与功能类共同实现一个接口。对代理类进行调用，运行代理功能加功能类功能。
```java
public interface User
{
    public void run();
} 

public class UserImp
{
    @Override
    public void run()
    {
        System.out.println("我是功能类的功能")
    }
}

public class UserProxy
{
    //功能类的引用
    private User user;

    //传入功能类
    public UserProxy(User user)
    {
        this.user = user;
    }

    //实现代理功能
    @Override
    public void run()
    {
        System.out.println("我是代理类功能1");
        user.run();
        System.out.println("我是代理类功能2");
    }
}

```
这种方式需要继承接口，并且为每个类实现一个代理类，代码的耦合度侵入性太高。
## 静态代理

在代码编译阶段生成时生成代理类并织入字节码中。可以在变量，方法调用，异常处理等上进行切面。
<br>AspectJ，是一种几乎和Java完全一样的语言，而且完全兼容Java，AspectJ应该就是一种扩展Java。有两种使用方式:

- 完全使用AspectJ的语言。这语言一点也不难，和Java几乎一样，也能在AspectJ中调用Java的任何类库。AspectJ只是多了一些关键词罢了。
- 使用AspectJ注解，简称@AspectJ,使用纯Java语言开发

**执行原理**:
<br>AspectJ是通过对目标工程的.class文件进行代码注入的方式将通知(Advise)插入到目标代码中。 
- 第一步：根据pointCut切点规则匹配的joinPoint； 
- 第二步：将Advise插入到目标JoinPoint中。 
<br>这样在程序运行时被重构的连接点将会回调Advise方法，就实现了AspectJ代码与目标代码之间的连接。

<br>关于AspectJ的用法以后用到再系统的学习。

## 动态代理
动态生成代理类，运行时(字节码加载入内存)动态生成代理类。局限于方法层面上(调用，报错等)的切面。(Spring AOP使用的方式)

### JDKProxy实现动态代理
JDK方式实现与静态代理看起来很类似(**功能类需要实现接口**)，动态生成实现功能类接口的代理类，使用InvocationHandler这个中介接口实现功能扩展，再通过Proxy类实现对中介接口类的代理化实例(代理类是被代理类的接口对象，接受Proxy.newProxyInstance()通过反射技术生成实现代理接口的匿名类的实例化)
```java
public interface User
{
    public void run();
} 

public class UserImp
{
    @Override
    public void run()
    {
        System.out.println("我是功能类的功能")
    }
}

public class UserProxy implements InvocationHandler { 
    
    //功能类的引用
    private User user; 
    public UserProxy(User user) 
    { 
        this.user = user; 
    } 

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable 
    { 
        System.out.println("我是代理类功能1"); 
        Object result = method.invoke(obj, args); 
        System.out.println("我是代理类功能2"); 
        return result; 
    } 

    //获取被代理接口实例对象
    public <T> T getProxy(User user) {
        return (T) Proxy.newProxyInstance(user.getClass().getClassLoader(),user.getClass().getInterfaces(),this;
    }
} 

/**
* 使用时
**/
{
    //通过反射技术获取代理类实例,将功能类的代理类的引用赋给user
    User user = (UserImp)(new UserProxy(new UserImp())).getProxy();
    //通过代理类对象调用代理类方法(接口的多方法都会被相对应的代理)，实际上会转到invoke方法调用 
    user.run();
}

```
- 在**运行阶段**通过反射生成实现了指定接口的代理类实例
- 为什么是使用接口? 由于java不支持多继承，所以JDK动态代理不能代理类
- 有一个静态代码块，通过反射或者代理类的所有方法
- 通过invoke执行代理类中的目标方法doSomething

### CGLIB框架实现动态代理

CGLIB(Code Generation Library)是一个基于ASM的字节码生成库，它允许在运行时对字节码进行修改和动态生成。对被代理对象类的class文件加载进来，通过修改其字节码生成子类来处理(在内存中修改，并不在编译的字节码文件中修改)(**继承功能类来实现**)

```java 
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;
import java.lang.reflect.Method;

// 功能类
public class User
{
    public void run()
    {
        System.out.println("我是功能类的功能")
    }
}

//代理类
public class UserProxy implements MethodInterceptor {
    private Enhancer enhancer = new Enhancer();
  
    
    
    @Override
    public Object intercept(Object object, Method method, Object[] args, MethodProxy methodProxy) throws Throwable {
        System.out.println("调用前");
        Object result = methodProxy.invokeSuper(object, args);
        System.out.println("调用后");
        return result;
    }

      //获取功能类
    public Object getProxy(Class clazz){
        //将功能类设为父类
        enhancer.setSuperclass(clazz);
        enhancer.setCallback(this);
        //用于创建无参的目标对象代理类，对于有参构造器则调用Enhancer.create(Class[] argumentTypes, Object[] arguments)，第一个参数表示参数类型，第二个参数表示参数的值。
        return enhancer.create();  
    }
}
/*使用*/
User user =(User) new UserProxy().getProxy(User.class);

//转到UserProxy的intercept方法，对功能类，也就是代理类的父类的非final方法(继承来的非final方法也会被代理)
user.run();
```
- 对这个对象所有非final方法的调用都会转发给MethodInterceptor.intercept()
- 代理类继承自功能类

**动态代理的AOP局限于方法拦截**。如果是单例的我们最好使用CGLib代理，如果是多例的我们最好使用JDK代理，原因是JDK在创建代理对象时的性能要高于CGLib代理，而生成代理对象的运行性能却比CGLib的低，如果是单例的代理，推荐使用CGLib。

## Spring AOP

Spring AOP的**注解@ASpectJ驱动的切面**本质实现还是基于**动态代理**方式，如果要代理的对象，实现了某个接口，那么Spring AOP会使用JDK Proxy，去创建代理对象，而对于没有实现接口的对象，就无法使用JDK Proxy去进行代理了，这时候Spring AOP会使用Cglib，生成一个被代理对象的子类，来作为代理。

## 基于@AspectJ注解的Spring AOP
> 底层还是基于**动态代理**方式

### 概念

- Aspect(切面):通常是一个需要被切入的类，里面可以定义切入点和通知
- Pointcut(切入点):就是带有通知的连接点，在程序中主要体现为书写切入点表达式(excution()表达式)
- excution()表达式

```
.. ：匹配方法定义中的任意数量的参数，此外还匹配类定义中的任意数量包
execution(public * *(..))//任意返回值，任意名称，任意参数的公共方法
within(com.zejian.dao..*) //匹配com.zejian.dao包及其子包中所有类中的所有方法

+ ：匹配给定类的任意子类
within(com.zejian.dao.DaoUser+)//匹配实现了DaoUser接口的所有子类的方法

* ：匹配任意数量的字符
within(com.zejian.service..*)//匹配com.zejian.service包及其子包中所有类的所有方法
execution(* set*(int)) //匹配以set开头，参数为int类型，任意返回值的方法

```
- Advice(通知):AOP在特定的切入点上执行的增强处理，有before,after,afterReturning,afterThrowing,around
- JointPoint(连接点):程序执行过程中明确的点，一般是方法的调用
- AOP代理:AOP框架创建的对象，代理就是目标对象的加强。Spring中的AOP代理可以使JDK动态代理，也可以是CGLIB代理，前者基于接口，后者基于子类

#### 例子
```java
@Aspect
public class Myaspect
{
    /*
    另一种指定切入点的方式
    @Pointcut("execution(返回类型(*表示所有返回类型) com.xiong.springdemo.springAopdemo.dao.UserDao.addUser(..))")
    public void pointCut(){}
    @Before(pointcut="pointCut()")
    */
    @Before("execution(返回类型(*表示所有返回类型) com.xiong.springdemo.springAopdemo.dao.UserDao.addUser(..))")
    public void before(){
        System.out.println("前置通知....");
    }
    
    //切点处理完返回值之后执行
    @AfterReturning(value="execution()",returning = "returnVal")
    public void AfterReturning(Object returnVal){
        System.out.println("后置通知...."+returnVal);
    }

    //环绕通知,在before之前,after之前
    @Around("execution()")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        System.out.println("环绕通知前....");
        Object obj= (Object) joinPoint.proceed();
        System.out.println("环绕通知后....");
        return obj;
    }

    //抛出异常时执行
    @AfterThrowing(value="execution()",throwing = "e")
    public void afterThrowable(Throwable e){
        System.out.println("出现异常:msg="+e.getMessage());
    }

    //切点执行的后运行，在返回之前
    @After("execution()")
    public void after(){
        System.out.println("最终通知....");
    }
}
```
**执行顺序:**
- Arount
- Before
- method() 
- Arount
- After
- (出现异常，处理完时执行)AfterThrowing
- AfterReturn


## Spring AOP执行顺序(同通知等级的AOP)

1. AOP对象实现org.springframework.core.Ordered类
<br>重写Aspect(切面)的getOrder()方法。  
```java
public int getOrder() {  
    return 2;  //数字越小优先级越高
}  
```
2. AOP对象加上@Order(1)

# Spring JDBC
Spring JDBC使得我们使用的时候更加注重sql语句逻辑，只有连接错误处理，关闭连接的操作由框架完成，Spring JDBC比java JDBC 更丰富的异常体系

## 数据访问

### 基于JDBC驱动的连接
```java
org.springframework.jdbc.datasource

@profile("") //可以根据不同环境选择数据库连接
@Bean
public DataSource dateSource(){
    DriverManagerDataSource dateSource =new DriverManagerDataSource();
    dateSource.setDriverClassName();
    dateSource.setURL()
    dateSource.setUsername();
    dateSource.setPassword();
    return dateSource
}

```
```xml
<bean id="dataSource"
class="org.springframework.jdbc.datasource.DriverManagerDataSource">
   <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
   <property name="url" value="jdbc:mysql://localhost:3306/TEST"/>
   <property name="username" value="root"/>
   <property name="password" value="password"/>
</bean>
```

## 数据库操作
java 原生JDBC对数据库的操作需要频繁的重复操作连接，捕获异常，关闭连接，代码太过于冗余，Spring JDBC对数据库执行操作进行封装，JdbcTemplate类，简化了很多，代码看起来也比较没那么乱，是线程安全的，可以多线程执行操作。
<br>jdbcTemplate装配到Repository中并使用它来访问数据库
```java
@Repository
public class JdbcSpitterRepository implements SpitterRepository {
    private JdbcOperations jdbcOperations;

    @Inject  //@Inject是根据类型进行自动装配的，如果需要按名称进行装配，则需要配合@Named
    public JdbcSpitterRepository(JdbcOperations jdbcOperations) {
        this.jdbcOperations = jdbcOperations;
    }
}

```
- Spring对jdbc异常转化为自己体现的异常
    - InvalidResultSetAccessException:无效的结果集合访问异常 
    - DataAccessException:数据访问异常
对于异常的具体信息，需要将异常通过getCause()返回SQLExcetion

#### 延迟加载--bean的lazy-init属性
看到JdbcTemplate的构造方法有一个boolean参数，是lazy_init,表示延迟加载，被使用的时候才被加载
<br>Spring Bean有个属性也是lazy-init类似的，被使用的时候才被加载，对于prototype多例来说本来是使用的时候(被getBean，被其他bean使用)被加载，而对于singleton单例来说，设置lazy-init可以使得被使用的时候被加载

#### JdbcTemplate类
<br>执行SQL语句，获得结果集，捕获异常并转换
##### 执行操作
如果不是简单的一个简单数据的查询，为了配合spring的Ioc和Aop思想，应该将这些操作进行整合，包装。既有一个对象数据访问对象掌控数据--DAO
- 一个DAO接口包含对对象包含所需要操作的
- 一个数据对象类
- 一个继承RowMapper的数据对象Mapapper类用来对结果集进行生成List操作
- 一个实现DAO接口的数据对象DAO类
    - 实现接口的数据访问操作(增删改查)
    - DataSouerce对象连接数据(通过注入)
    - JdbcTemplate对象(通过注入)实现sql操作
    - 数据对象

这样满足Ioc如果对于数据对象DAO接口的操作可以通过Aop进行扩展
##### 结果获取
- ResultSetExtractor接口

```java
jdbcTemplate.query(sql,
               new ResultSetExtractor(){
                   @Override
                   public Object extractData(ResultSet rs) throws SQLException,
                           DataAccessException {
                       while (rs.next()) {
                           rs.getByXxxx();
                       }
                       return 0;
                   }
               }
               );
```
相对于java的jdbc的结果集获取需要自己写next(),通过实例化接口的匿名类来传参
- RowCallbackHandler接口

```java
 jdbcTemplate.query(sql, new RowCallbackHandler() {
           @Override
           public void processRow(ResultSet rs) throws SQLException {
               System.out.print(rs.getString("actor_id"));
               System.out.print(" "+rs.getString("first_name"));
               System.out.print(" "+rs.getString("last_name"));
               System.out.println();
           }
       });
```
对ResultSetExtractor操作的简化使得只要写即可每次的操作即可，循环判断由spring完成
- RowMapper接口

返回值为List<自定义类型>，这个接口将查询结果返回为自定义的类的List
```java
List<E> elist = (List<E>)EDao.getJdbcTemplate().  
query("select * from T_USER", new RowMapper(){  
            @Override  
            public Object mapRow(ResultSet rs, int rowNumber)   
throws SQLException {  
                E e = new E();  
                E.setXxx(rs.getXxx());  
                E.setXxx(rs.getXxx());  
                elist.add(e)
                return user;  
            }  
      });  
```
### 事务管理编程式与声明式
- 编程式事务管理就是在程序中使用beginTransaction()、commit()、rollback()等事务管理相关的方法来执行事务操作,程序中使用Spring的api但是实际上是使用持久化框架来实现的
- 声明式事务管理使用Spring的AOP技术进行方法拦截进行事务管理,所有声明式的最小粒度就是在方法上
```xml
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
       <property name="dataSource" ref="dataSource"/>
       <property name="configLocation" value="classpath:applicationContext-mybatis.xml"/>
</bean>
<bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource" />
</bean>
<tx:annotation-driven transaction-manager="txManager" />
```
## 持久化框架
## Hibernate
## Mybatis
### Mybatis配置文件
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
### 数据类创建
创建数据类用来保存数据,成员设置成setXxx()格式,类似与bean,或者就是bean。
### 创建Mapper接口
XxxMapper接口用来定义操作方法,用来映射到接下来的Mapper配置文件中来映射sql操作,并设置参数，就像preparstatement里的占位符，可以通过方法参数传入。然后返回值为数据类对象,或者就是简单数据类型。
### 创建Mapper.xml配置文件
配置文件用来映射到对象中
```xml
    <!--一对一映射resultMap类型-->
    <mapper namespace="com.xiong.Mapper接口">
        <resultMap id="对象id" type="数据类">
            <result property="成员变量" column="字段名" />
        </resultMap>
        <!-- 根据id查询用户 -->
        <select id="方法名" parameterType="需要填入的数据类型" resultMap="resultMap对象id">
            sql语句
        </select>
    </mapper>
    <!--通过resultType类型映射-->
    <mapper namespace="com.xiong.ActorMapper">
        <select id="findByname" parameterType="com.xiong.Actor" resultType="int">
            SELECT actor_id FROM actor WHERE first_name=#{first_name} AND last_name=#{last_name}
        </select>
    </mapper>
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

## Spring WebFlux

### 使用过程

1. 取出Request body到Mono<>或Flux<>

```java
Mono <String> Monostring = request.bodyToMono(String.class);
//或
Mono <String> Monostring = request.body(BodyExtractors.toMono(String.class));

```

2. 


## Spring Security
开启Security

### 
```java
@Configuration
//@EnaleGlobalMethodSecurity(jsr250Enabled=true)//@@RolesAllowed java标准方式
//@EnaleGlobalMethodSecurity(securityEnabled=true)//@Secured注解方式
public class MethodSecurityConfig extends GlobalMethodSecurityConfig{
}
```
### @Secured



## 注解笔记

### @ComponentScan[(basePackages={"",""})]
开启扫描

### Bean注册注解

- @Component
声明这是个组件类，在**类定义时**使用并生成bean，默认生成Bean名字为该类的第一个字母小写。在@Component中调用@Bean注解的方法和字段则是普通的Java语义，不经过CGLIB处理

- @Configration
@Configuration标注在类上，相当于把该类作为spring的xml配置文件中的<beans>，作用为：配置spring容器(应用上下文)，在内部定义@Bean都会被动态代理,因此调用该方法返回的都是同一个实例


- @Bean
注解在方法上，返回一个对象(这个对象就是bean)，默认注解的**方法名**作为对象的名字，也可以@Bean(name="beanname")

- @Controller

- @Repository

- @Service


### Bean注入注解

- @AutoWired
为类对象注入bean，通过类型进行注入
<br>如果查询的结果不止一个，那么@Autowired会根据名称来查找。也可以使用加上@Qualifier("BeanName")注解指定名称查询
<br>如果查询的结果为空，那么会抛出异常。解决方法时，使用required=false

- @Resource
为类对象以Bean名字注入

- @Profile(active)

@Profile("dev")它会告诉Spring这个配置类中的bean只有在dev profile激活时才会创建。如果
dev profile没有激活的话，那么带有@Bean注解的方法都会被忽略掉

- @GetMapping

@RequestMapping(method = RequestMethod.GET)的缩写

- @PostConstruct

  在spring的Bean中按照**Constructor构造方法**、**@Autowired**依赖依赖注入、**@PostConstruct**方法顺序执行。

- 


# 后缀
在spring接口或是类会带上一些后缀比如Factory，Aware等 