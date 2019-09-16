# Lambda表达式
```java
{
    new Thread(()->{
            System.out.println("1: Sleeping");
            try {
                TimeUnit.SECONDS.sleep(5);
                System.out.println("1: Sleep Over");
            }catch (InterruptedException ie)
            {
                System.out.println(ie.getMessage());
            }
        }).start();
    }

```
## 格式
```java
(Type1 param1, Type2 param2, ..., TypeN paramN) -> {
  statment1;
  statment2;
  //.............
  return statmentM;
}
```
## 变量的引用
**匿名内部类**在访问外部变量的时候，**外部变量**必须用**final**修饰。现在java8对这个限制做了优化，可以不用显示使用final修饰，但是编译器**隐式当成final**来处理。<br>

## this
在lambda中，this不是指向lambda表达式产生的那个SAM对象，而是声明它的**外部对象**。





# Stream
是数据渠道，用于操作数据源(集合、数组、文件等)所生成的元素序列。集合讲的是数据，流讲的是计算,不对**源数据**进行操作

$\color{red}{注意}$：

Stream只是一个计算通道，自己不会存储元素；

Stream不会改变源对象，相反，他们会返回一个新的Stream对象。

Stream操作是延时的，只有在执行终止操作时才会执行。

## 生成stream

- **Stream的静态方法 of**可以将数组转换为Stream

```
Stream<> stream = Stream.of(数组);
```

- 集合的静态方法**.stream()**;

```
Stream<> stream = list.stream();
```

- **Arrays.stream()**

```
Arrays.stream(T[] array) //全部
<br>Arrays.stream(T[] array, int start, int end) // 一部分
```

- Stream的静态方法 empty() 可以创建空的stream

- Stream的的静态方法generate() 可以产生一个特定的值的stream

```
Stream<String> stream = Stream.generate(() -> "java");  
```

## 中间操作

- Filter

过滤元素
<br>接受一个布尔型返回值函数作为参数，该函数用Lambda表达式表示,false则滤掉
- Reduce

感觉类似递归，累加


- distinct()

返回一个去除重复元素之后的Stream。
```
Stream<String> stream= Stream.of("I", "love", "you", "too", "too");
stream.distinct().forEach(str -> System.out.println(str));
```
上述代码会输出去掉一个too之后的其余字符串。

- sorted()
    排序函数有两个
    - 自然顺序排序

    Stream<T>　sorted()

    - 自定义比较器排序

    Stream<T>　sorted(Comparator<? super T> comparator)。

    ```
    Stream<String> stream= Stream.of("I", "love", "you", "too");
    stream.sorted((str1, str2) -> str1.length()-str2.length()).forEach(str -> System.out.println(str));

    ```
- map()

返回一个对当前所有元素执行执行mapper之后的结果组成的Stream。就是对每个元素按照某种操作进行转换，转换前后Stream中元素的个数不会改变，但元素的类型取决于转换之后的类型。
```
Stream<String> stream　= Stream.of("I", "love", "you", "too");
stream.map(str -> str.toUpperCase()).forEach(str -> System.out.println(str));
//上述代码将输出原字符串的大写形式。
```

- flatMap()

是对每个元素执行mapper指定的操作，并用所有mapper返回的Stream中的元素组成一个新的Stream作为最终返回结果。flatMap()的作用就相当于把原stream中的所有元素都"摊平"之后组成的Stream，转换前后元素的个数和类型都可能会改变。扁平化。

```
Stream<List<Integer>> stream = Stream.of(Arrays.asList(1,2), Arrays.asList(3, 4, 5));
stream.flatMap(list -> slist.stream()).forEach(i -> System.out.println(i));
上述代码中，原来的stream中有两个元素，分别是两个List<Integer>，执行flatMap()之后，将每个List都“摊平”成了一个个的数字，所以会新产生一个由5个数字组成的Stream。所以最终将输出1~5这5个数字。

```
- limit(long maxSize)

截断流，使其元素不超过给定数量
- skip(long n)

跳过元素，返回一个扔掉了前n个元素的流。若流中元素不足n个，则返回一个空流。与limit（n）互补

## 终端操作

- Collect

在流中生成集合 如List<T> toList()
```
.stream().collect(Collectors.toList())
```

- forEach()

迭代遍历流中的每一个数据

```
Stream<String> stream = Stream.of("I", "love", "you", "too");
stream.forEach(str -> System.out.println(str));

```
- count()

跟List接口的size一样，返回的都是这个集合流的元素的长度，不同的是，流是集合的一个高级工厂，中间操作是工厂里的每一道工序，我们对这个流操作完成后，可以进行元素的数量的和；
- anyMatch()

判断的条件里，任意一个元素成功，返回true

- allMatch()

判断条件里的元素，所有的都是，返回true

- noneMatch()

跟allMatch相反，判断条件里的元素，所有的都不是，返回true

- findFirst()

返回第一个元素

- findAny()

返回当前流中的任意元素

- count()

返回流中元素的总数

- max(Comparator c)

返回流中的最大值

- min(Comparator c)

返回流中的最小值

- reduce(BinaryOperator b)

可以将流中元素通过方法里的操作反复结合起来，得到一个值，返回Optional类



## 并行流





# 参考资料



[jdk8的新特性总结（二）：StreamAPI](https://blog.csdn.net/caishi13202/article/details/82631779)

