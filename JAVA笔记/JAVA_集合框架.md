<h1>Java集合框架</h1>



# Collection接口



## List接口(extends Collection)

### Vector类
使用synchronized保证线程安全。默认扩容翻倍

### Stack类(extends Vector)
实现栈，先进后出
- push 进栈
- pop 出栈 EmptyStackException异常
- peek 返回栈顶 EmptyStackException异常

### ArrayList类
与Vector基本相同，非线程安全。ArrayList扩容增加50%的大小，有利于节约内存空间。

## Set接口(extends Collection)
集合，不可重复

### HashSet
底层实现还是HashMap，不保证顺序，允许使用 null 元素，非线程安全



## Queue接口(extends Collection)


# Map接口
键值对

## HashMap类
数组+链表实现。
- 扩容问题

loadFactor 扩容因子，达到百分比进行扩容操作
<br>initialCapacity 初始容量。

**扩容2幂次倍**
1. h&(length-1)，不是2次幂的话length-1 二进制最后一位为0。那么为hash值二进制最后一位0的这个位置被浪费了。
2. table中的元素只有两种情况：
元素hash值第N+1位为0：不需要进行位置调整
元素hash值第N+1位为1：调整至原索引的两倍位置


