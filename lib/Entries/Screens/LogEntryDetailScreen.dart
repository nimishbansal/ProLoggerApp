import 'package:flutter/material.dart';

import 'package:pro_logger/Entries/LogEntry.dart';
import 'package:pro_logger/ThemeManager/widgets/ThemeChangerInheritedWidget.dart';
import '../../main.dart';

class LogEntryDetailScreen extends StatefulWidget {
  final String title;
  final String message;
  final LogEntry logEntry;
  final int id;

  LogEntryDetailScreen(
      {Key key,
      @required this.id,
      this.title,
      this.message,
      @required this.logEntry})
      : super(key: key);

  @override
  _LogEntryDetailScreenState createState() => _LogEntryDetailScreenState();
}

class _LogEntryDetailScreenState extends State<LogEntryDetailScreen> {
  @override
  Widget build(BuildContext context) {
//    ThemeChangerInheritedWidget.of(context).switchTheme(Theme.of(context).copyWith(primaryColor: Colors.red));
    const List<Choice> choices = const <Choice>[
      const Choice(title: 'Car', icon: Icons.directions_car),
      const Choice(title: 'Bicycle', icon: Icons.directions_bike),
      const Choice(title: 'Boat', icon: Icons.directions_boat)
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(this.widget.title),
        actions: <Widget>[
          Builder(
            builder: (context) => PopupMenuButton<Choice>(
              onSelected: (choice) => _select(choice, context),
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Material(
                child: new Text(
              widget.logEntry.message,
              style: TextStyle(fontSize: 20),
            )),
          ),
        ],
      ),
    );
  }

  void _select(Choice value, BuildContext context) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value.title + " selected"),
    ));
  }
}
