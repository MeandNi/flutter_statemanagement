import 'package:statepro/commonstate/main.dart' as commonstate;
import 'package:statepro/inheritedValue/main.dart' as inheritedWidget;
import 'package:statepro/scoped/main.dart' as scoped;
import 'package:statepro/bloc_cart/main.dart' as bloc;
import 'package:statepro/bloc_counter/main.dart' as bloc_counter;
import 'package:statepro/bloc_inherited/main.dart' as bloc_inherited;
import 'package:statepro/redux_counter/main.dart' as redux_counter;
import 'package:statepro/redux_cart/main.dart' as redux_cart;


void main() {
  final flavor = Architecture.bloc_inherited;

  print("\n\n===== Running: $flavor =====\n\n");

  switch (flavor) {
    case Architecture.commomstate:
      commonstate.main();
      return;
    case Architecture.inheritedWidget:
      inheritedWidget.main();
      return;
    case Architecture.bloc_counter:
      bloc_counter.main();
      return;
    case Architecture.bloc_inherited:
      bloc_inherited.main();
      return;
    case Architecture.scoped:
      scoped.main();
      return;
    case Architecture.bloc:
      bloc.main();
      return;
    case Architecture.redux_counter:
      redux_counter.main();
      return;
    case Architecture.redux_cart:
      redux_cart.main();
      return;
  }
}

enum Architecture {
  commomstate,
  inheritedWidget,
  bloc_counter,
  bloc_inherited,
  scoped,
  bloc,
  redux_counter,
  redux_cart
}