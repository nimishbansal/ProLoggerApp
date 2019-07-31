import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Screens/LogEntryListScreen.dart';
import 'package:pro_logger/utility/LogLevel.dart';

import 'ThemeManager/widgets/ThemeSwitcherWidget.dart';

void main() => runApp(MyApp());

class Choice {
  final title, icon;

  const Choice({this.title, this.icon});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutThemeContainer(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(primaryColor: white),
          home: Padding(
            padding: const EdgeInsets.all(4),
            child: LogEntryListScreen(),
          ),
        ));
  }
}
