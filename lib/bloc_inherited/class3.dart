
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:statepro/bloc_inherited/count_bloc_provider.dart';
import 'package:statepro/bloc_inherited/counter_block.dart';

class Class3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CounterBloc bloc = CountBlocProvider.of(context).bloc;
    return StreamBuilder<int>(
      stream: bloc.itemCount,
      initialData: 0,
      builder: (context, snapshot) => Text(
            "Class 3 : ${snapshot.data}",
            style: Theme.of(context).textTheme.headline,
          ),
    );
  }
}