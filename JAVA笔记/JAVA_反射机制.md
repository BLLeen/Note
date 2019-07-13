# 反射机制
对于任意类，都知道类的方法与属性，对于任意对象，都可以调用对象的方法，知道属性值。
类被加载，jvm会在内存中创建一个class对象。

## 获取类对象(Class类)
- 类名.class

JVM将使用该类的类装载器, 将该类装入内存(前提是该类还没有装入内存)，不对类A做类的初始化工作，返回类A的Class的对象。

- 对象.getClass()

放回该类真正所指的对象(子类对象的引用可能赋值给父类对象的引用变量中)所属的类的class对象
```java
Class Son extends Father{};
Father fa =new Son();
System.out.println(fa.getClass()) //class Main2.Son
```
- Class.forName(全限定类名)

装入该类,并做该类的初始化(如果还没被初始化)

## 获取类构造方法(Constructor类)
```java
类名.getConstructors() //返回Constructor<?>[]

Constructor constructor;
Class[] parameters=constructor.getParameterTypes();//获取参数类型 返回Class对象数组

```
## 获取属性(Field类)

```java

Field fields[] = userClass.getDeclaredFields();// 获取当前类所有声明的属性
Field fields[] = cl.getFields();// 获取公有属性(包括父类)
Field.setAccessible(fields,true);//取消安全检查
//或
files[0].setAccessible(true);//分别进行取消安全检查

```
## 获取方法(Method类)

```java
Method[] methods = userClass.getDeclaredMethods(); //获取当前类声明的方法    
Method[] methods = userClass.getMethods();//获取公有方法(包括父类)
Method.setAccessible(methods, true);// 取消安全性检查,设置后才可以调用private修饰的方法，也可以单独对某个方法进行设置

/**
获取参数类型：getParameterTypes()
获取返回类型：getReturnType()
*/

//调用方法
methods[0].invoke(Object obj, Object... args);
/*
    obj是方法的调用者
    args是参数列表
*/

```