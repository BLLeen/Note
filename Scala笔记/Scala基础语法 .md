# 方法和函数

- **方法**（Method）：是类的**成员方法**，与java的函数没什么区别，类内部使用，或是类外部 [类|对象].方法名()引用
- **函数**（Function）：函数是一个**对象**可以赋值给一个变量

有的教程认为函数方法没有什么区别。scala函数式编程，所以函数是其核心。

### Scala 函数传名调用(call-by-name)

Scala的解释器在解析以**函数**为**入参**(function arguments)时有两种方式：

- 传值调用（call-by-value）：先计算参数表达式的值，再应用到函数内部，相对于运行函数再传返回值；
- 传名调用（call-by-name）：将未计算的参数表达式直接应用到函数内部，内部使用该参数调用再运行；

org.apache.spark.deploy.worker.Worker spark://localhost:7077

./bin/spark-submit --master spark://localhost:7077 --class WordCount /sparkdemo.jar