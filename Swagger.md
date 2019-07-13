# 依赖
# Swagger2配置类
```java

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
public class Swagger2 {
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.xiong.demoserver.controller"))
                .paths(PathSelectors.any())
                .build()
                .apiInfo(apiInfo());
    }
    private ApiInfo apiInfo(){
        return new ApiInfoBuilder()
                .title("Demo API")
                .description("Demo项目接口")
                .termsOfServiceUrl(" API terms of service")
                .version("1.0.0")
                .build();
    }
}

```
## 注解
### @Api() 
用于类；表示标识这个类是swagger的资源 
<br>tags–表示说明 
<br>value–也是说明，可以使用tags替代,但是tags如果有多个值，会生成多个list
```java
@Api(value="用户controller",tags={"用户操作接口"})
@RestController
public class UserController {
}
```
### @ApiOperation() 
用于方法；表示一个http请求的操作 
<br>value用于方法描述 
<br>notes用于提示内容 
<nr>tags可以重新分组（视情况而用） 
### @ApiParam() 
用于方法，参数，字段说明；表示对参数的添加元数据（说明或是否必填等） 
<br>name–参数名 
<br>value–参数说明 
<br>required–是否必填
```java
@Api(value="用户controller",tags={"用户操作接口"})
@RestController
public class UserController {
     @ApiOperation(value="获取用户信息",tags={"获取用户信息copy"},notes="注意问题点")
     @GetMapping("/getUserInfo")
     public User getUserInfo(@ApiParam(name="id",value="用户id",required=true) Long id,@ApiParam(name="username",value="用户名") String username) {
    
      User user = userService.getUserInfo();
      return user;
  }
}
```
## @ApiModel()
用于类 ；表示对类进行说明，用于参数用实体类接收 
<br>value–表示对象名 
<br>description–描述 
都可省略 
## @ApiModelProperty()
用于方法，字段； 表示对model属性的说明或者数据操作更改 
<br>value–字段说明 
<br>name–重写属性名字 
<br>dataType–重写属性类型 
<br>required–是否必填 
<br>example–举例说明 
<br>hidden–隐藏
```java
@ApiModel(value="user对象",description="用户对象user")
public class User implements Serializable{
    private static final long serialVersionUID = 1L;
     @ApiModelProperty(value="用户名",name="username",example="xingguo")
     private String username;
     @ApiModelProperty(value="状态",name="state",required=true)
      private Integer state;
      private String password;
      private String nickName;
      private Integer isDeleted;

      @ApiModelProperty(value="id数组",hidden=true)
      private String[] ids;
      private List<String> idList;
     //省略get/set
}
```
## @ApiIgnore()
用于类或者方法上，可以不被swagger显示在页面上 

## @ApiImplicitParam() 
用于方法,表示单独的请求参数 
## @ApiImplicitParams() 
用于方法，包含多个 @ApiImplicitParam 
<br>name–参数名
<br>value–参数说明 
<br>dataType–数据类型 
<br>paramType–参数类型 
<br>example–举例说明
```java
@ApiOperation("查询测试")
@GetMapping("select")
//@ApiImplicitParam(name="name",value="用户名",dataType="String", paramType = "query")
@ApiImplicitParams({
@ApiImplicitParam(name="name",value="用户名",dataType="string", paramType = "query",example="xingguo"),

@ApiImplicitParam(name="id",value="用户id",dataType="long", paramType = "query")
})
public void select(){
}
```