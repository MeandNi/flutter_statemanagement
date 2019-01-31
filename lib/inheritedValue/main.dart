import 'package:statepro/inheritedValue/model.dart';
import 'package:flutter/material.dart';
import 'package:statepro/inheritedValue/my_inheritedWidget.dart';

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
      home: InheritedWidgetTestContainer(),
    );
  }
}

class InheritedWidgetTestContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _InheritedWidgetTestContainerState();
  }
}

class _InheritedWidgetTestContainerState
    extends State<InheritedWidgetTestContainer> {
  InheritedTestModel inheritedTestModel;

  _initData() {
    inheritedTestModel = new InheritedTestModel(0);
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _incrementCount() {
    setState(() {
      inheritedTestModel = new InheritedTestModel(inheritedTestModel.count + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MyInheritedValue(
        inheritedTestModel: inheritedTestModel,
        increment: _incrementCount,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('InheritedWidgetTest'),
          ),
          body: Center(
            child: new Text(
              '来自inheritedTestModel的值：${inheritedTestModel.count}',
              style: new TextStyle(fontSize: 20.0),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _incrementCount,
          ),
        ));
  }
}
