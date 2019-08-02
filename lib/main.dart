import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Screens/LogEntryListScreen.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';

void main() => runApp(CustomTheme(
      child: MyApp(),
      initialThemeData:
          ThemeData(primaryColor: Color(0xFFFFFF).withAlpha(0xFF)),
    ));

class Choice {
  final title, icon;

  const Choice({this.title, this.icon});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LogEntryListScreen(),
      theme: CustomTheme.of(context),
    );
  }
}
