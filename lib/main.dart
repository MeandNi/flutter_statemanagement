import 'package:statepro/commonstate/main.dart' as commonstate;
import 'package:statepro/inheritedValue/main.dart' as inheritedWidget;
import 'package:statepro/scoped/main.dart' as scoped;
import 'package:statepro/bloc/main.dart' as bloc;
import 'package:statepro/bloc_counter/main.dart' as bloc_counter;

void main() {
  final flavor = Architecture.bloc_counter;

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
    case Architecture.scoped:
      scoped.main();
      return;
    case Architecture.bloc:
      bloc.main();
      return;
  }
}

enum Architecture {
  commomstate,
  inheritedWidget,
  bloc_counter,
  scoped,
  bloc
}