# 引用类型转换
子类可以**自然的**转化为父类，父类转化为子类是有条件的

## 例子
```java

@AllArgsConstructor
public class Father
{
    String f;
}

@AllArgsConstructor
public class Son extends Father
{
    String s;
}

```

## 子类转化为父类
```java
Son son =new Son("f_property","s_property");

//son功能强，被转化为father，则被削弱，因为s这个属性无法被使用 因为没办法father.s
Father father = (Father)son;
father.f;
//s这个属性无法被使用，但是实例内存中有这个属性
```
father -> "son"{ f= "f_property";s= "s_property"}
<br>father引用指向son实例内存，但是s= "s_property"对于father引用是不可访问的



## 父类转化子类(报错情况)
```java
Father father = new Father("f_property");

//father功能强，被转化为son，则被加强，因为father这个内存内没有这个s属性，所有son的s属性无法被满足
Son son = (Son) father;
//抛出ClassCastException异常信息
```
son -> "father"{ f= "f_property";}
<br>son引用类型志向father实例内存，但是father实例缺少s属性，所有无法类型转换

## 父类转化子类(可装换情况)
```java
Son son =new Son("f_property","s_property");
Father father = (Father)son; //father -> "son"{ f= "f_property";s= "s_property"}
Son son1 = (Son)father; //son1 -> father -> "son"{ f= "f_property";s= "s_property"}
```
father指向的内存空间是"son"{ f= "f_property";s= "s_property"}，此时son1需要father的转换为Son，father的指向实例内存{ f= "f_property";s= "s_property"}，son1成功指向内存实例
