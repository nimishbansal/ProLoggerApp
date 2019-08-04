import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Screens/LogEntryListScreen.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';

import 'Entries/widgets/LogLevelSelectModal.dart';

void main() => runApp(CustomTheme(
      child: MyApp(),
      initialThemeData:
          ThemeData(primaryColor: Color(0xFFFFFF).withAlpha(0xFF)),
    ));

class Choice {
  final title, icon;

  const Choice({this.title, this.icon});
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: RaisedButton(
      child: Text('Open Dialog'),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return LogLevelSelectModalWidget();
            });
      },
    )));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
//      home: LogEntryListScreen(),
      home: LogEntryListScreen(),
      theme: CustomTheme.of(context),
    );
  }
}
