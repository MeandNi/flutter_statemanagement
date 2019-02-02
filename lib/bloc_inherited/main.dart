import 'package:flutter/material.dart';
import 'package:statepro/bloc_inherited/class2.dart';
import 'package:statepro/bloc_inherited/count_bloc_provider.dart';
import 'package:statepro/bloc_inherited/counter_block.dart';
import 'package:statepro/bloc_inherited/mycounter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage();

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var myCounter = new MyCounter(0);
    CounterBloc bloc = CounterBloc();
    return CountBlocProvider(
      bloc: bloc,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Default",
            ),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Class2(),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
              ),
            ],
          )),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              bloc.add.add(myCounter);
            },
          )),
    );
  }
}