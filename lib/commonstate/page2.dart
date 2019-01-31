import 'package:flutter/material.dart';

class PageTwo extends StatefulWidget {
  final int count;
  final Function increment;

  const PageTwo({Key key, this.count, this.increment}) : super(key: key);

  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  void incrementInTwoPage() {
    widget.increment();
    setState(() {
    });
  }

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
        onPressed: incrementInTwoPage,
      ),
    );
  }
}