利用 Flutter 内置的许多控件我们可以打造出一款不仅漂亮而且完美跨平台的 App 外壳，我利用其特性完成了类似[知乎App的UI界面](https://github.com/MeandNi/Flutter_ZhiHu)，然而一款完整的应用程序显然不止有外壳这么简单。填充在外壳里面的是数据，数据来源或从本地，或从云端，大量的数据处理很容易造成数据的混乱，耦合度提高，不便于维护，于是诞生了很多设计模式和状态管理的方式。

目前 Flutter 常用状态管理方式有如下几种：

- ScopedModel
- BLoC (Business Logic Component) / Rx
- Redux

这篇文章暂且不提这些比较复杂的模式。我们简单的提出三个问题：

- Flutter 中组件之间如何通信？
- 更新 State 后组件以何种方式重新渲染？
- 如何在路由转换之间保持状态同步？



###  初探 State

我以创建新项目 Flutter 给我们默认的计数器应用为例，通过路由我将其拆分为两部分 `MyHomePage`和 `PageTwo`，

MyHomePage，持有一个`_counter`变量和一个增加计数的方法，PageTwo，接收两个参数(计数的至和增加计数的方法)：

```dart

class PageTwo extends StatefulWidget {
  final int count;
  final Function increment;

  const PageTwo({Key key, this.count, this.increment}) : super(key: key);

  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Two"),
      ),
      body: Center(
        child: Text(widget.count.toString(), style: TextStyle(fontSize: 30.0),),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: widget.increment,
      ),
    );
  }
}


```

出现的状况是：我们在首页点击按钮触发计数器增加，路由到 PageTwo 后，数值正常显示，然而点击这个界面中的 add 按钮该页面的数值并未发生改变，通过观察父页面的 count 值确实发生了改变，因此再次通过路由到第二个界面界面才显示正常。解答上面三个问题：

- Flutter 中组件之间如何通信？

  参数传递。

- 更新 State 后组件以何种方式重新渲染？

  只渲染当前的组件（和子组件，这里暂未证明，但确实是触发 SetSate() 后，其所有子组件都将重新渲染。）

- 如何在路由转换之间保持状态同步？

  父组件传递状态值到子组件，子组件拿到并显示，但却不能实时更改😀，我一时半会还正没想出什么解决方法，我相信即使能做到也不优雅。

证明触发 SetSate() 后，其所有子组件都将重新渲染：我在副组件中添加两个子组件，一旦触发渲染变打印相关数据：

```dart
TestStateless(),
TestStateful()

class TestStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build TestStateless');
    return Text('TestStateless');
  }
}

class TestStateful extends StatefulWidget {
  @override
  _TestStatefulState createState() => _TestStatefulState();
}

class _TestStatefulState extends State<TestStateful> {
  @override
  Widget build(BuildContext context) {
    print('build TestStateful');
    return Text('_TestStatefulState');
  }
}
```

此时到 PageTwo 触发 add 事件，日志出来：

![](/images/flutterstate1.png)

通过这种简单的方式已经可以说明一个问题，即以最简单的方式我们已经可以完成状态传递和组件渲染，而路由间保持状态一致还不能解决。

### InheritedWidget

Google 官方给我们的解决方案是 ` InheritedWidget`，怎么理解他，我们可以称它为“状态树”，它使得所有的 widget 的 State 来源统一，这样一旦有一处触发状态改变，Flutter 以某种方式感应到了（有个监听器），砍掉它，长出一个新树，Perfect！所有地方都能感受到他的变化。上面提到的第一种状态管理方式 `ScopedModel`便是基于此而产生的一套第三方库。

其实现在看来 InheritedWidget 已经非常简单了，我们抓住两个点即可完全掌握它：

1. 状态树中的数据

   ```dart
   class MyInheritedValue extends InheritedWidget {
     const MyInheritedValue({
       Key key,
       @required this.value,
       @required Widget child,
     }) : assert(value != null),
          assert(child != null),
          super(key: key, child: child);
     final int value;
     static MyInheritedValue of(BuildContext context) {
       return context.inheritFromWidgetOfExactType(MyInheritedValue);
     }
     @override
     bool updateShouldNotify(MyInheritedValue old) => 
           value != old.value;
   }
   ```

   注入到根组件中：

   ```dart
   Widget build(BuildContext context) {
     return MyInheritedValue(
       value: 42,
       child: ...
     );
   }
   ```

2. 使用状态树中数据的其他 Widget

   ```
   // 拿到状态树中的值
   MyInheritedValue.of(context).value
   ```

   请注意：这种情况下是不能改 InheritedWidget 中的值的，需要改也很简单就是将 MyInheritedValue 的值封装成一个对象，每次改变这个对象的值，具体法相看我的实例代码！

上面所说砍掉整棵树过于粗暴却并不夸张，因为一处改变它将联动整棵树，

ScopedModel 是基于 InheritedWidget 的库，实现起来与 InheritedWidget 大同小异，而且其有一种可以让局部组件不改变的方式：设置 rebuildOnChange 为 false。

```dart
return ScopedModelDescendant<CartModel>(
          rebuildOnChange: false,
          builder: (context, child, model) => ProductSquare(
                product: product,
                onTap: () => model.add(product),
              ),
        );
```

具体代码请看 GitHub，ScopedModel 样例截取一个老外给的实例，就是下方参考链接 Google 开发者大会上演讲的那两位其中之一。

这种方式显然有点不足之处就是一旦遇到小规模变动就要引起大规模重新渲染，所以当项目达到一定的规模考虑 Google 爸爸给我们的另一种解决方案。

### Streams（流）

在 Android 开发中我们经常会用到 RxJava 这类响应式编程方法的框架，其强大之处无须多言，而 Stream 看上去就是在 Dart 语言中的响应式编程的一种实现。

- Streams 是什么鬼？

  如果要具体把 Streams 说清楚，一篇文章绝对不够，这里先介绍一下其中的概念，这篇文章目的就是如此。待我后续想好怎么具体描述清楚。

  你可以把它想象成一个管道，有入口（StreamSink）和出口（），我们将想要处理的数据从入口放入经过该管道经过一系列处理（经由 *StreamController*）从出口中出来，而出口又有一个类似监听器之物，我们不知道它何时到来或者何时处理结束。但是当出口的监听器拿到东西便立即做出相应的反应。
- 那些东西可以放入管道？
  任何变量、对象、数组、甚至事件都可以被当作数据源从入口放进去。

- Streams 种类
  1. Single-subscription Stream，“单订阅”流，这种类型的流只允许在该流的整个生命周期内使用单个侦听器。即使在第一个订阅被取消后，也无法在此类流上收听两次。
  2. Broadcast Streams，第二种类型的Stream允许任意数量的侦听器。可以随时向广播流添加侦听器。 新的侦听器将在它开始收听 Stream 时收到事件。

 例子：

第一个示例显示了“单订阅”流，只打印输入的数据。 你会发现是哪种数据类型无关紧要。

```dar
import 'dart:async';

void main() {
  //
  // Initialize a "Single-Subscription" Stream controller
  //
  final StreamController ctrl = StreamController();
  
  //
  // Initialize a single listener which simply prints the data
  // as soon as it receives it
  //
  final StreamSubscription subscription = ctrl.stream.listen((data) => print('$data'));

  //
  // We here add the data that will flow inside the stream
  //
  ctrl.sink.add('my name');
  ctrl.sink.add(1234);
  ctrl.sink.add({'a': 'element A', 'b': 'element B'});
  ctrl.sink.add(123.45);
  
  //
  // We release the StreamController
  //
  ctrl.close();
}
```

第二个示例显示“广播”流，它传达整数值并仅打印偶数。 我们用 StreamTransformer 来过滤（第14行）值，只让偶数经过。

```dart
import 'dart:async';

void main() {
  //
  // Initialize a "Broadcast" Stream controller of integers
  //
  final StreamController<int> ctrl = StreamController<int>.broadcast();
  
  //
  // Initialize a single listener which filters out the odd numbers and
  // only prints the even numbers
  //
  final StreamSubscription subscription = ctrl.stream
					      .where((value) => (value % 2 == 0))
					      .listen((value) => print('$value'));

  //
  // We here add the data that will flow inside the stream
  //
  for(int i=1; i<11; i++){
  	ctrl.sink.add(i);
  }
  
  //
  // We release the StreamController
  //
  ctrl.close();
}
```



### RxDart

RxDart包是 ReactiveX API 的 Dart 实现，它扩展了原始的 Dart Streams API 以符合 ReactiveX 标准。

![](/images/flutterstate2.png)

由于它最初并未由 Google 定义，因此它使用不同于 Dart 的变量。 下表给出了 Dart 和 RxDart 之间的关系。

| Dart             | RxDart     |
| ---------------- | ---------- |
| Stream           | Observable |
| StreamController | Subject    |

RxDart 扩展了原始的 Dart Streams API 并提供了 StreamController 的3个主要变体：

1. PublishSubject

   PublishSubject 是一个普通的 **broadcast** StreamController ，有一点不同：stream 返回一个 Observable 而不是一个 Stream 。

   ![](/images/flutterstate3.png)

   如您所见，PublishSubject 仅向侦听器发送在订阅之后添加到 Stream 的事件。

2.  BehaviorSubject

   BehaviorSubject 也是一个 broadcast StreamController，它返回一个 Observable 而不是一个Stream。

   ![](/images/flutterstate4.png)

   与 PublishSubject 的主要区别在于 BehaviorSubject 还将最后发送的事件发送给刚刚订阅的侦听器。

3. ReplaySubject

   ReplaySubject 也是一个广播 StreamController，它返回一个 Observable 而不是一个 Stream。(萝莉啰嗦)

   ![](/images/flutterstate5.png)

   默认情况下，ReplaySubject 将Stream 已经发出的所有事件作为第一个事件发送到任何新的侦听器。

### BloC

BLoC 代表业务逻辑组件 (**B**usiness **Lo**gic **C**omponent)。

简而言之，业务逻辑需要：

- 被移植到一个或几个 BLoC 中，
- 尽可能从表示层中删除。 也就是说，UI组件应该只关心UI事物而不关心业务，
- 依赖 Streams 使用输入（Sink）和输出（*stream*），
- 保持平台独立，
- 保持环境独立。

事实上，BLoC 模式最初的设想是实现允许独立于平台重用相同的代码：Web应用程序，移动应用程序，后端。

Bloc 的大概就是 Stream 在 Flutter 中的最佳实践：

![](/images/flutterstate6.png)

- 组件通过 Sinks 向 BLoC 发送事件，
- BLoC 通过 stream 通知组件，
- 由 BLoC 实现的业务逻辑。

将 BloC 应用在计数器应用中：

```dart
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Streams Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<IncrementBloc>(
          bloc: IncrementBloc(),
          child: CounterPage(),
        ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IncrementBloc bloc = BlocProvider.of<IncrementBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Stream version of the Counter App')),
      body: Center(
        child: StreamBuilder<int>(
          stream: bloc.outCounter,
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot){
            return Text('You hit me: ${snapshot.data} times');
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          bloc.incrementCounter.add(null);
        },
      ),
    );
  }
}

class IncrementBloc implements BlocBase {
  int _counter;

  //
  // Stream to handle the counter
  //
  StreamController<int> _counterController = StreamController<int>();
  StreamSink<int> get _inAdd => _counterController.sink;
  Stream<int> get outCounter => _counterController.stream;

  //
  // Stream to handle the action on the counter
  //
  StreamController _actionController = StreamController();
  StreamSink get incrementCounter => _actionController.sink;

  //
  // Constructor
  //
  IncrementBloc(){
    _counter = 0;
    _actionController.stream
                     .listen(_handleLogic);
  }

  void dispose(){
    _actionController.close();
    _counterController.close();
  }

  void _handleLogic(data){
    _counter = _counter + 1;
    _inAdd.add(_counter);
  }
}
```

你一定在说，卧槽，哇靠～～什么吊玩意，那么就留着悬念吧，今天写不动了！

这篇文章的目的就是介绍一些概念给大家关于 Streams、RXDart 及 Bloc 详细明了的解释后续更新！



### 参考链接

[Build reactive mobile apps with Flutter (Google I/O '18)](https://www.youtube.com/watch?v=RS36gBEp8OI&index=115&list=PLOU2XLYxmsIInFRc3M44HUTQc3b_YJ4-Y)

[Reactive Programming - Streams - BLoC](https://www.didierboelens.com/2018/08/reactive-programming---streams---bloc/)