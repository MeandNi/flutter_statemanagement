import 'package:flutter/cupertino.dart';
import 'package:statepro/inheritedValue/model.dart';

class MyInheritedValue extends InheritedWidget {
  //数据
  final InheritedTestModel inheritedTestModel;

  //增加方法
  final Function() increment;

  MyInheritedValue({
    Key key,
    @required this.inheritedTestModel,
    @required this.increment,
    @required Widget child,
  }) : super(key: key, child: child);

  static MyInheritedValue of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(MyInheritedValue);
  }

  //是否重建widget就取决于数据是否相同
  @override
  bool updateShouldNotify(MyInheritedValue oldWidget) {
    return inheritedTestModel != oldWidget.inheritedTestModel;
  }
}