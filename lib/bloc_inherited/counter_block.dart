import 'dart:async';

import 'package:statepro/bloc_inherited/mycounter.dart';

class CounterBloc {

  final additionController = StreamController<MyCounter>();

  Sink<MyCounter> get add => additionController.sink;

  final itemController = StreamController<int>();

  Stream<int> get itemCount => itemController.stream;

  CounterBloc() {
    additionController.stream.listen(onAdd);
  }

  void onAdd(MyCounter myCounter) {
    myCounter.increaseCount();
    itemController.add(myCounter.counter);
  }
}