

## 使用原生API发送请求

1. 通过统一资源定位器(java.net.URL)获取连接器(java.net.URLConnection)
2. 设置请求的参数
3. 发送请求
4. 以输入流的形式获取返回的内容 
5. 关闭输入流

## URL格式
> protocol://hostname:port[/path][:parameter][?query][#fragment]

- protocol 协议，常用的协议是http
- hostname 主机地址，可以是域名，也可以是IP地址
- port 端口 http协议默认端口是：80端口，如果不写默认就是:80端口
- path 路径 网络资源在服务器中的指定路径
- parameter 参数 如果要向服务器传入参数，在这部分输入
- query 查询字符串 如果需要从服务器那里查询内容，在这里编辑
- fragment 片段 网页中可能会分为不同的片段，如果想访问网页后直接到达指定位置，可以在这部分设置

## Http请求格式

1. 请求方法

GET和POST是最常见的HTTP方法，除此以外还包括DELETE、HEAD、OPTIONS、PUT、TRACE。不过，当前的大多数浏览器只支持GET和POST，Spring 3.0提供了一个HiddenHttpMethodFilter，允许你通过“_method”的表单参数指定这些特殊的HTTP方法（实际上还是通过POST提交表单）。服务端配置了HiddenHttpMethodFilter后，Spring会根据_method参数指定的值模拟出相应的HTTP方法，这样，就可以使用这些HTTP方法对处理方法进行映射了。 

2. 请求对应的URL地址
它和报文头的Host属性组成完整的请求URL, http://hostname:port[/path][:parameter][?query][#fragment]

3. 协议名称及版本号
比如HTTP/1.1

4. HTTP的报文头
报文头包含若干个属性，格式为“属性名:属性值”，服务端据此获取客户端的信息。


```
    # 公共头部
 Remote Address	        请求的远程地址
 Request URL	        请求的域名
 Request Method	        页面请求的方式：GET/POST
 Status Code	        请求的返回状态
    # 请求头
 Accept	                表示浏览器支持的 MIME 类型
 Accept-Encoding	    浏览器支持的压缩类型
 Accept-Language	    浏览器支持的语言类型，并且优先支持靠前的语言类型
 Cache-Control	        指定请求和响应遵循的缓存机制 
 Connection	            当浏览器与服务器通信时对于长连接如何进行处理：close/keep-alive
 Cookie	                向服务器返回cookie，这些cookie是之前服务器发给浏览器的
 Host	                请求的服务器URL
 Referer	            该页面的来源URL
 User-Agent	            用户客户端的一些必要信息
    # 返回头
 Cache-Control	        告诉浏览器或者其他客户，什么环境可以安全地缓存文档
 Connection	            当client和server通信时对于长链接如何进行处理
 Content-Encoding	    数据在传输过程中所使用的压缩编码方式
 Content-Type	        数据的类型
 Date	                数据从服务器发送的时间
 Expires	            应该在什么时候认为文档已经过期，从而不再缓存它？
 Server	                服务器名字。Servlet一般不设置这个值，而是由Web服务器自己设置
 Set-Cookie	            设置和页面关联的cookie
 Transfer-Encoding	    数据传输的方式 
```

5. 报文体
它将一个页面表单中的组件值通过param1=value1&param2=value2的键值对形式编码成一个格式化串，它承载多个请求参数的数据。不但报文体可以传递请求参数，请求URL也可以通过类似于
“https://www.baidu.com/baidu?isource=infinity&iname=baidu&itype=web&tn=98012088_9_dg&ch=7&ie=utf-8”的方式传递请求参数。 

# JDK原生包(java.net.URL)

## 创建URL

```java
String url = "https://www.baidu.com/"
URL localURL = new URL(url);  //获取URL
```

## 创建连接

通过URL实例创建生成连接(转化为HttpURLConnection连接)
```java
HttpURLConnection httpURLConnection = (HttpURLConnection)localURL.openConnection();
```
### 对于Post方法
```java 
    // StringBuffer parameterBuffer Bodyneir
    httpURLConnection.setDoOutput(true);
    httpURLConnection.setRequestMethod("POST");
    httpURLConnection.setRequestProperty("Accept-Charset", charset);
    httpURLConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
    httpURLConnection.setRequestProperty("Content-Length", String.valueOf(parameterBuffer.length()));


    //创建输出流，将请求体发送到服务器
    OutputStreamWriter outputStreamWriter = null;
    try {
            outputStreamWriter = new OutputStreamWriter(httpURLConnection.getOutputStream());
            outputStreamWriter.write(parameterBuffer.toString());
            outputStreamWriter.flush();
            //响应失败
            if (httpURLConnection.getResponseCode() >= 300) {
                throw new Exception("HTTP Request is not success, Response code is " + httpURLConnection.getResponseCode());
            }
    }catch( Exception e ){}

``` 

## 从连接中获取输入流
通过httpURLConnection获取输入流

```java 

//响应失败
if (httpURLConnection.getResponseCode() >= 300) 
{
    throw new Exception("HTTP Request is not success, Response code is " + httpURLConnection.getResponseCode());
}

// 响应成功
try {
        BufferedReader breader = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream()));
    
        while ((tempLine = reader.readLine()) != null) 
        {
            resultBuffer.append(tempLine);
        }

        } finally {
            if (reader != null) {
                reader.close();
            }
            if (inputStreamReader != null) {
                inputStreamReader.close();
            }
            if (inputStream != null) {
                inputStream.close();
            }
        }
       String responsstr = resultBuffer.toString();
```


