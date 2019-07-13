# 跨域问题
跨域问题是前端会遇到的问题，由于浏览器的同源策略(属于不同域的页面之间不能相互访问各自的页面内容cookie)限制了从同一个源加载的文档或脚本如何与来自另一个源的资源进行交互。这是一个用于隔离潜在恶意文件的重要安全机制
# 分析
首先对单点登陆问题进行分析
## 概念
SSO(Single Sign-On)，中文意即单点登录，单点登录是一种控制**多个**相关但**彼此独立**(同域或不同域)的**系统**的访问权限, 拥有这一权限的用户可以使用**单一的ID和密码**并且在**访问其中一个系统时实现认证**在后续访问某个或多个系统从而避免使用不同的用户名或密码，或者通过某种配置无缝地登录每个系统。

![](I:\Mydoc\系统架构笔记\pic\SSO_1.png)

![](I:\Mydoc\系统架构笔记\pic\SSO方案1.png)

### 用户角度：

- 登陆一次输入用户密码(在login.taobao.com这个页面)
- 点击不同选项进行浏览很无缝连接(从www.i.taobao.com页面跳转到www.cart.taobao.com页面)
- 点击天猫(www.tmall.com)依旧无缝连接
### 后端逻辑
- www.i.taobao.com -> www.cart.taobao.com  (同域下的两个系统理论上需要两个系统都需要验证用户合法性)
- www.taobao.com -> www.tmall.com (跨域的两个系统也需要验证合法性)



# 方案1(同域)



1. User 发送登录请求给SSO-Server，附上自己的 ID 和 password；
2. SSO验证成功将用户信息保存在公共缓存 Cache 中；
3. User每次发送请求给系统 Ai 时，将 ID 作为请求参数；
4. 系统 Application i 通过请求中传过来的 User ID从公共缓存 Cache 中验证 User 是否登录，完成后续动作；

**分析**：适用于同一域中，并Cookie中保存SessionID，然后Session info保存在Redis Cache中

# 方案2(跨域)



与方案1类似，不同之处在于，访问第二个系统时会带着验证信息去SSO服务器获取验证SeesionID

# JWT验证方式
不需要去第三方服务器进行验证，当然登录验证还是需要的。

![](I:\Mydoc\系统架构笔记\pic\JWT_1.png)

流程如下：

1. 客户端使用账户密码请求登录接口
2. 登录成功后服务器使用**签名密钥**生成JWT ,然后返回JWT给客户端
3. 客户端再次向服务端请求其他接口时带上JWT
4. 服务端接收到JWT后**验证签名的有效性**.对客户端做出相应的响应

## JWT生成

JSON Web Token说到底也是一个token字符串,它由三部分组成，**头部**、**载荷**与**签名**。

### 头部（Header） 
JWT的头部用于描述关于该JWT的最基本的信息，例如其类型以及签名所用的算法等。这可以被表示成一个JSON对象。

```jso
{
  "typ": "JWT",
  "alg": "HS256"
}
（在这里，我们说明了这是一个JWT，并且我们所用的签名算法是HS256算法）
```

对它进行Base64编码，之后的字符串就成了JWT的Header（头部）。

```
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9
```

### 载荷(playload) 
在载荷(playload)中定义了以下属性

```json
{
   "iss": "该JWT的签发者" 
   "sub": "该JWT所面向的用户" 
   "aud": "接收该JWT的一方" 
   "exp(expires)": "什么时候过期，这里是一个Unix时间戳" 
   "iat(issued at)": "在什么时候签发的"
}
```

也可以用一个JSON对象来描述 
将上面的JSON对象进行[base64编码]可以得到下面的字符串。这个字符串我们将它称作JWT的Payload（载荷）。

```
eyJpc3MiOiIyOWZmMDE5OGJlOGM0YzNlYTZlZTA4YjE1MGRhNTU0NC1XRUIiLCJleHAiOjE1MjI0OTE5MTV9
```

### 签名（Signature） 
在加密的时候，验证服务器需要提供一个密钥（secret）并保存在服务器。在官方文档中是如下描述的

```
HMACSHA256( base64UrlEncode(header) + "." + base64UrlEncode(payload),secret)
```

即如下操作 
将上面的两个[base64编码]后的字符串都用句号.连接在一起（头部在前），就形成了如下字符串

```
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIyOWZmMDE5OGJlOGM0YzNlYTZlZTA4YjE1MGRhNTU0NC1XRUIiLCJleHAiOjE1MjI0OTE5MTV9
```

最后，我们将上面拼接完的字符串用HS256算法进行加密。那么就可以得到我们加密后的内容 

```
P-k-vIzxElzyzFbzR4tUxAAET8xT9EP49b7hpcPazd0 
```

这个就是我们JWT的签名了

这些拼在一起以"."连接

```
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIyOWZmMDE5OGJlOGM0YzNlYTZlZTA4YjE1MGRhNTU0NC1XRUIiLCJleHAiOjE1MjI0OTE5MTV9.P-k-vIzxElzyzFbzR4tUxAAET8xT9EP49b7hpcPazd0 
```

## 分析

1. 可以在本服务器上验证token的真实性，因为签名算法不可以被伪造
2. 服务器需要记住secret，会加大负担
3. 传输的流量变大
4. 被劫持依然没办法保证安全，需要安全还是需要https

