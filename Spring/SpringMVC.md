
### Spring MVC

参考资料：[springMVC学习](https://www.iteye.com/blogs/subjects/springMVC)

## Controller

参考博客：[**SpringMVC Controller 介绍**](https://www.iteye.com/blog/elim-1753271)

##### @Controller

**@RestController**相当于每个方法加上**@ResponseBody**

用于标记在一个类上，使用它标记的类就是一个SpringMVC Controller 对象。分发处理器将会扫描使用了该注解的类的方法，并检测该方法是否使用了@RequestMapping 注解。

##### @RequestMapping("")
用来处理xxx请求地址映射的注解，可用于类或方法上。用于类上，表示类中的所有响应请求的方法都是以该地址作为父路径。
<br>方法的返回值会被SpringMCV配置文件中的解析器解析为物理视图既为prefix/返回值/suffix(/WEB-INF/jsp/xxx.jsp)

```xml
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/jsp/" />
        <property name="suffix" value=".jsp" />
</bean>
```
#### @RequestMapping 处理器方法支持的方法参数和返回类型

##### 支持的参数类型

（1 ）**HttpServlet 对象，主要包括HttpServletRequest 、HttpServletResponse 和HttpSession对象。**这些参数Spring 在调用处理器方法的时候会自动给它们赋值，所以当在处理器方法中需要使用到这些对象的时候，可以直接在方法上给定一个方法参数的申明，然后在方法体里面直接用就可以了。但是有一点需要注意的是在使用HttpSession 对象的时候，如果此时HttpSession 对象还没有建立起来的话就会有问题。

（2 ）**Spring 自己的WebRequest 对象。** 使用该对象可以访问到存放在HttpServletRequest 和HttpSession 中的属性值。

（3 ）**InputStream 、OutputStream 、Reader 和Writer 。** InputStream 和Reader 是针对HttpServletRequest 而言的，可以从里面取数据；OutputStream 和Writer 是针对HttpServletResponse 而言的，可以往里面写数据。

（4 ）**使用@PathVariable 、@RequestParam 、@CookieValue 和@RequestHeader 标记的参数。**

（5 ）**使用@ModelAttribute 标记的参数。**

（6 ）**java.util.Map 、Spring 封装的Model 和ModelMap 。** 这些都可以用来封装模型数据，用来给视图做展示。  

（7 ）**实体类。** 可以用来接收上传的参数。

（8 ）**Spring 封装的MultipartFile 。** 用来接收上传文件的。

（9 ）**Spring 封装的Errors 和BindingResult 对象。** 这两个对象参数必须紧接在需要验证的实体对象参数之后，它里面包含了实体对象的验证结果。

##### 支持的返回类型

（1 ）**一个包含模型和视图的ModelAndView 对象。**

（2 ）**一个模型对象，这主要包括Spring 封装好的Model 和ModelMap ，以及java.util.Map 。**当没有视图返回的时候视图名称将由RequestToViewNameTranslator 来决定。

（3 ）**一个View 对象。**这个时候如果在渲染视图的过程中模型的话就可以给处理器方法定义一个模型参数，然后在方法体里面往模型中添加值。

（4 ）**一个String 字符串。**这往往代表的是一个**视图名称**。这个时候如果需要在渲染视图的过程中需要模型的话就可以给处理器方法一个模型参数，然后在方法体里面往模型中添加值就可以了。

（5 ）**返回值是void 。**这种情况一般是我们直接把返回结果写到HttpServletResponse 中了，如果没有写的话，那么Spring 将会利用RequestToViewNameTranslator 来返回一个对应的视图名称。如果视图中需要模型的话，处理方法与返回字符串的情况相同。

（6 ）如果处理器方法被注解**@ResponseBody **标记的话，那么处理器方法的任何返回类型都会通过HttpMessageConverters 转换之后写到HttpServletResponse 中，而不会像上面的那些情况一样当做视图或者模型来处理。

（7 ）除以上几种情况之外的其他任何返回类型都会被**当做模型中的一个属性**来处理，而返回的**视图**还是由**RequestToViewNameTranslator 来决定**，添加到模型中的属性名称可以在该方法上用@ModelAttribute(“attributeName”) 来定义，否则将使用返回类型的类名称的首字母小写形式来表示。使用@ModelAttribute 标记的方法会在@RequestMapping 标记的方法执行之前执行。

##### @RequestMapping的请求

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

如果希望服务器输出什么浏览器就能看到什么，那么在服务器端都要以字符串的形式进行输出

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