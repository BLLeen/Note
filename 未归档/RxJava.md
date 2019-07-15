参考资料
[RxJava 详解](https://gank.io/post/560e15be2dca930e00da1083)
# 概念及原理
## RxJava 的观察者模式

- Observable(可观察者，被观察者)
- Observer(观察者)
- subscribe (订阅)
- 事件

被观察者和观察者通过subscribe()方法实现订阅关系，从而被观察者可以在需要的时候发出**事件**来通知观察者

## 创建观察者(Observer)

```java 
Observer<String> observer = new Observer<String>() {
    
    @Override
    public void onNext(String s) {
        Log.d(tag, "Item: " + s);
    }

    //事件队列完结。RxJava 不仅把每个事件单独处理，还会把它们看做一个队列。RxJava 规定，当不会再有新的 onNext() 发出时，需要触发 onCompleted() 方法作为标志。
    @Override
    public void onCompleted() {
        Log.d(tag, "Completed!");
    }

    //事件队列异常。在事件处理过程中出异常时，onError() 会被触发，同时队列自动终止，不允许再有事件发出。
    @Override
    public void onError(Throwable e) {
        Log.d(tag, "Error!");
    }
};
```
Observer接口之外，RxJava还内置了一个实现了Observer的抽象类Subscriber。Subscriber对Observer 接口进行了一些扩展，但他们的基本使用方式是完全一样的。
<br>在 RxJava 的 subscribe 过程中，Observer 也总是会先被转换成一个 Subscriber 再使用。所以如果你只想使用基本功能，选择 Observer 和 Subscriber 是完全一样的。它们的区别对于使用者来说主要有两点：
1. onStart(): 
<br>这是 Subscriber 增加的方法。它会在 subscribe 刚开始，而**事件还未发送之前**被调用，可以用于做一些准备工作，例如数据的清零或重置。这是一个可选方法，默认情况下它的实现为空。需要注意的是，如果对准备工作的线程有要求（例如弹出一个显示进度的对话框，这必须在主线程执行）， onStart() 就不适用了，因为它总是在 **subscribe 所发生的线程**被调用，而不能指定线程。要在指定的线程来做准备工作，可以使用 doOnSubscribe()方法，具体可以在后面的文中看到。
2. unsubscribe(): 
<br>这是 Subscriber 所实现的另一个接口 Subscription 的方法，用于**取消订阅**。在这个方法被调用后，Subscriber 将不再接收事件。一般在这个方法调用前，可以使用 **isUnsubscribed()** 先判断一下状态。 unsubscribe() 这个方法很重要，因为在 subscribe() 之后， Observable 会持有 Subscriber 的引用，这个引用如果不能及时被释放，将有内存泄露的风险。所以最好保持一个原则：要在不再使用的时候尽快在合适的地方（例如 onPause() onStop() 等方法中）调用 unsubscribe() 来解除引用关系，以避免内存泄露的发生。

## 创建被观察者(Observable)
Observable 即被观察者，它决定什么时候触发事件以及触发怎样的事件。 RxJava 使用 create() 方法来创建一个 Observable ，并为它定义事件触发规则：
```java
Observable observable = Observable.create(new Observable.OnSubscribe<String>() {
    @Override
    public void call(Subscriber<? super String> subscriber) {
        subscriber.onNext("Hello");
        subscriber.onNext("Hi");
        subscriber.onNext("Aloha");
        subscriber.onCompleted();
    }
});
```
传入了一个**OnSubscribe**对象作为参数。OnSubscribe 会被存储在返回的 Observable 对象中，它的作用相当于一个计划表，当 Observable 被订阅的时候，OnSubscribe 的 call() 方法会自动被调用，事件序列就会依照设定依次触发（对于上面的代码，就是观察者Subscriber 将会被调用三次 onNext() 和一次 onCompleted()）。这样，由被观察者调用了观察者的回调方法，就实现了由被观察者向观察者的事件传递，即观察者模式
```java
//just(T...): 将传入的参数依次发送出来。
Observable observable = Observable.just("Hello", "Hi", "Aloha");

//from(T[]) / from(Iterable<? extends T>) : 将传入的数组或 Iterable 拆分成具体对象后，依次发送出来
String[] words = {"Hello", "Hi", "Aloha"};
Observable observable = Observable.from(words);
```
## Subscribe (订阅)
创建了 Observable 和 Observer 之后，再用 subscribe() 方法将它们联结起来，整条链子就可以工作了
```java
observable.subscribe(observer);
// 或者：
observable.subscribe(subscriber);
```
为什么是**被观察者**订阅**观察者**(**订阅者**)？个人理解是，observable将事件流向observer，所以需要获取每个Observer的对象，相对于Observer表，然后有事件，就流行这些observer。如果是observer订阅observable，observable就没办法主动将事件发送到observer了。

```java
//订阅的核心代码
public Subscription subscribe(Subscriber subscriber) {
    // 1.调用 Subscriber.onStart() 。这个方法在前面已经介绍过，是一个可选的准备方法。
    subscriber.onStart();

    // 2.调用 Observable 中的 OnSubscribe.call(Subscriber) 。在这里，事件发送的逻辑开始运行。从这也可以看出，在 RxJava 中， Observable 并不是在创建的时候就立即开始发送事件，而是在它被订阅的时候，即当 subscribe() 方法执行的时候。
    // 3.将传入的 Subscriber 作为 Subscription 返回。这是为了方便 unsubscribe().
    onSubscribe.call(subscriber);
    
    
    return subscriber;
    
  
}
```
