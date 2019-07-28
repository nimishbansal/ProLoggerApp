

import 'package:flutter/material.dart';
import 'package:pro_logger/utility/LogLevel.dart';

class ThemeChangerWidget extends InheritedWidget {

    final ThemeData themeData;

    ThemeChangerWidget({this.themeData, Key key, @required Widget child,}) :
                super(key: key, child: child);


  static ThemeChangerWidget of(BuildContext context) {
      return context.inheritFromWidgetOfExactType(ThemeChangerWidget);
  }

  @override
  bool updateShouldNotify(ThemeChangerWidget oldWidget) {
    return oldWidget.themeData == themeData;
  }
}
