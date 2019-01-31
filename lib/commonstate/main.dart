import 'package:flutter/material.dart';
import 'package:statepro/commonstate/page2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            new RaisedButton(
              child: new Text('Next Screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new PageTwo(
                      count: _counter,
                      increment: _incrementCounter,
                    ),
                  ),
                );
              },
            ),
            TestStateless(),
            TestStateful()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

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
