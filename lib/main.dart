import 'package:statepro/commonstate/main.dart' as commonstate;
import 'package:statepro/inheritedValue/main.dart' as inheritedWidget;
import 'package:statepro/scoped/main.dart' as scoped;

void main() {
  final flavor = Architecture.scoped;

  print("\n\n===== Running: $flavor =====\n\n");

  switch (flavor) {
    case Architecture.commomstate:
      commonstate.main();
      return;
    case Architecture.inheritedWidget:
      inheritedWidget.main();
      return;
    case Architecture.scoped:
      scoped.main();
      return;
  }
}

enum Architecture {
  commomstate,
  inheritedWidget,
  scoped
}