
### Spring MVC



##### @Controller
用于标记在一个类上，使用它标记的类就是一个SpringMVC Controller 对象。分发处理器将会扫描使用了该注解的类的方法，并检测该方法是否使用了@RequestMapping 注解。

##### @RequestMapping("/xxx")
用来处理xxx请求地址映射的注解，可用于类或方法上。用于类上，表示类中的所有响应请求的方法都是以该地址作为父路径。
<br>方法的返回值会被SpringMCV配置文件中的解析器解析为物理视图既为prefix/返回值/suffix(/WEB-INF/jsp/xxx.jsp)
```xml
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/jsp/" />
        <property name="suffix" value=".jsp" />
</bean>
```
###### @RequestMapping的请求
除了URL请求外，还可以使用请求方法，请求参数，请求头来精确映射请求。value(URL)、method(请求方法)、params(请求参数) 及 heads(请求头)。
####### params 和 headers支持简单的表达式：
- param1: 表示请求必须包含名为 param1 的请求参数 
- !param1: 表示请求不能包含名为 param1 的请求参数 
- param1 != value1: 表示请求包含名为 param1 的请求参数，但其值不能为 value1 
- {“param1=value1”, “param2”}: 请求必须包含名为 param1 和param2的两个请求参数数，且 param1 参数的值必须为 value1

##### @PathVariable
```java
@RequestMapping(value = "/test/{username}")
String test(@PathVariable("username")String username){}
```
可获取占位符的值
##### HiddenHttpMethodFilter过滤器
在restful架构中实现表现层状态转化,既URL是资源或是服务,不是具体的操作,那将操作交给请求方式实现，需要实现GET用来获取资源，POST用来新建更新资源，PUT用来更新资源，DELETE用来删除资源。通过POST方式模拟这四种操作。
<br>首先是配置这个过滤器
```xml
<filter>
    <filter-name>HiddenHttpMethodFilter</filter-name>
    <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
</filter>

    <!--配置对那些进行过滤,这里过滤所有请求-->
<filter-mapping>
    <filter-name>HiddenHttpMethodFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>

```
视图的写法(这是一个模拟Get请求对应于select获取)
```jsp
<form action="/xxx/参数(比如id)" method="post">
    <input type="hidden" name="_method" value="GET">
    <input type="submit" value="submit">
</form>
```
Controller的写法(这里控制在页面上输出得到的参数,id)
```java
@Controller
public class HMethodFilterTest {
    @RequestMapping(value = "/xxxx/{参数名}",method = RequestMethod.PUT)
    @ResponseBody
    String toputtest(@PathVariable("参数名") String id) {
        return id;
    }
}

```
#### @RequestParam
获取URL上?xx=xx&xx=xx上的参数
<br>@RequestParam(value="xx",required=true,default="xx")是否必须,无值时默认值是xx
#### @RequestHeader
用法与RequestParam类似,获取如下信息的参数
[Header](http://pcpj2g4mj.bkt.clouddn.com/18-8-9/17628758.jpg)
#### @CookieValue
获取Header上的cookie值
#### pojo作为参数
可将表单里的信息获取，以普通实体类的方式获得，直接在mapping方法中设参即可，可以级联属性,级联属性在表单里通过对象名.属性作为表单的name,如name="address.id"
#### mapping方法使用servlet原生的API
mappring的方法可以使用以下servlet原生API
```servlet
1.HttpServletRequest
2.HttpServletResponse
3.HttpSession
4.Writer
5.Reader
6.OutputStream
7.InputStream
8.java.security.Principal
```
#### 处理模型数据ModelAndView (请求域内)
ModelAndView类就是Model+View在view上添加Model模型
```java

public ModelAndView modelAndView(){
    ModelAndView modelAndView=new ModelAndView("index");//视图
    modelAndView.addObject("World","hello");//添加键值对
    return  modelAndView;//返回一个添加了数据模型的键值对
}
/*在Jsp视图中可以使用的时候*/
${requestScope.Word}的方式获取这个键的值

```
#### Map方式进行处理 (请求域内)
往Mapping方法内传入Map参数,往Map对象内放入数据,即可数据绑定到视图上
```java
public String MapTest(Map map)
{
    map.put("names", Arrays.asList("lin","song","xiong"));
    return "index";
}
//与ModelAndView类似可以通过${requestScope.names}的方式获取这个键的值

```

### SpringMVC常用注解
#### @Controller
负责注册一个bean 到spring 上下文中
#### @RequestMapping
注解为控制器指定可以处理哪些 URL 请求
#### @RequestBody
该注解用于读取Request请求的body部分数据，使用系统默认配置的HttpMessageConverter进行解析，然后把相应的数据绑定到要返回的对象上 ,再把HttpMessageConverter返回的对象数据绑定到 controller中方法的参数上
#### @ResponseBody
该注解用于将Controller的方法返回的对象，通过适当的HttpMessageConverter转换为指定格式后，写入到Response对象的body数据区
#### @SessionAttributes
这个注解的作用是将数据模型存放在session中就不仅仅是请求域里面
```java
//使用方法是修饰Controller类,然后指定需要放入session域中的数据,可以是普通参数,也可以是参数类型
@SessionAttributes(types = {User.class,Dept.class},value={“attr1”,”attr2”})
```
#### @ModelAttributes
- 在<strong>方法定义<strong>上使用@ModelAttribute注解:Spring MVC 在调用目标处理方法前，会先逐个调用在方法级上标注了@ModelAttribute 的方法
- 在<strong>方法的入参前<strong>使用@ModelAttribute注解:可以从隐含对象中获取隐含的模型数据中获取对象，再将请求参数–绑定到对象中，再传入入参将方法入参对象添加到模型中(用于数据的修改操作)

#### @RequestParam　
在处理方法入参处使用 @RequestParam 可以把请求参数传递给请求方法
#### @PathVariable
获取URL占位符处的数据到方法参数上
#### @ExceptionHandler
注解到方法上，出现异常时会执行该方法
#### @ControllerAdvice
使一个Contoller成为全局的异常处理类，类中用@ExceptionHandler方法注解的方法可以处理所有Controller发生的异常

### HttpServletRequest类和HttpServletResponse类

#### HttpServletRequest
代表请求对象,包含客户机信息
- getRequestURL  返回客户端发出请求时的完整URL。
- getRequestURI  返回请求行中的资源名部分。
- getQueryString 返回请求行中的参数部分。
- getPathInfo    返回请求URL中的额外路径信息。额外路径信息是请求URL中的位于Servlet的路径之后和查询参数之前的内容，它以“/”开头。
- getRemoteAddr  返回发出请求的客户机的IP地址。
- getRemoteHost  返回发出请求的客户机的完整主机名。
- getRemotePort  返回客户机所使用的网络端口号。
- getLocalAddr   返回WEB服务器的IP地址。
- getLocalName   返回WEB服务器的主机名。

客户机请求参数(客户端提交的数据)
- getParameter(String) 
- getParameterValues(String name)
- getParameterNames()
- getParameterMap()方法

#### HttpServletResponse
服务端响应对象
向客户端发送信息的方法
- getOutputStream() 返回一个ServletOutputStream类用来字节流传输
- getWriter() 返回一个java.io.PrintWriter类来传输字符流

### 隐藏域
在RESTful写求方式的时候用到了type="hidden"这个属性,这个属性代表这个标签是对于客户端不可见的

### 如果希望服务器输出什么浏览器就能看到什么，那么在服务器端都要以字符串的形式进行输出

### 将数据模型对象传入视图层
1. ModelAndView
处理方法返回值类型为 ModelAndView时, 方法体即可通过
```java
ModelAndView modelAndView = new ModelAndView(ViewName)//也就是jsp的名字
```
为对象添加模型数据

2. Map及Model 
入参为org.springframework.ui.Model、org.springframework.ui.ModelMap 或 java.uti.Map 时，处理方法返回时，Map中的数据会自动添加到模型中

3. @SessionAttributes
将模型中的某个属性暂存到HttpSession 中，以便多个请求之间可以共享这个属性
//SessionAttributes仅可以作用于类型，其作用是从request中选择需要的属性加入到Session
//可以用注解的默认参数value，在SessionAttributes注解中也可以把value用他的别名names替换。
//另外，用types，还可以把request中指定类型的所有属性加到Session中