import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Blocs/LogEntryBloc.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';
import 'package:pro_logger/main.dart';
import 'package:pro_logger/Entries/widgets/LogEntryCard.dart';
import 'package:pro_logger/utility/LogLevel.dart';

class LogEntryListScreen extends StatefulWidget {
  final String title;
  LogEntryListScreen({Key key, this.title}) : super(key: key);

  final ThemeData screenDefaultTheme = ThemeData(primaryColor: white);

  @override
  _LogEntryListScreenState createState() => _LogEntryListScreenState();
}

class _LogEntryListScreenState extends State<LogEntryListScreen> {
  LogEntryBloc _logEntryBloc;
  var _logEntries = List<LogEntry>();

  void addDataToList(dynamic data) {
    setState(() {
      _logEntries.length += 1;
      _logEntries.setRange(1, _logEntries.length, _logEntries);
      _logEntries
          .setRange(0, 1, [LogEntry.fromJson(json.decode(data.toString()))]);
    });
  }

  @override
  void initState() {
    super.initState();
    _logEntryBloc = new LogEntryBloc();
    _logEntryBloc.fetchLogEntriesList();
  }

  void getLogEntries(LogEntryRepository repository) async {
    var entries = await repository.fetchLogEntryList();
    setState(() {
      _logEntries.addAll(entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => changeThemeAfterBuild(context));

    const List<Choice> choices = const <Choice>[
      const Choice(title: 'Car', icon: Icons.directions_car),
      const Choice(title: 'Bicycle', icon: Icons.directions_bike),
      const Choice(title: 'Boat', icon: Icons.directions_boat)
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        title: Text("Issues"),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                stream: _logEntryBloc.logEntryStream,
                builder: (context, snapshot) {
                  print("has data ${snapshot.hasData}");
                  print("data ${snapshot.data}");

                  if (snapshot.hasData) {
                    return Container(
                        child: _myListView(context, snapshot.data),
                        height: MediaQuery.of(context).size.height - 100);
                  } else {
                    return new Image(image: new AssetImage("images/loader.gif"));
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context, List<LogEntry> logEntries) {
    return ListView.builder(
      itemCount: logEntries.length,
      itemBuilder: (context, index) {
        return LogEntryCard(
          key: ValueKey(logEntries[index]),
          logEntry: logEntries[index],
        );
      },
    );
  }

  void _select(Choice value, BuildContext context) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value.title + " selected"),
    ));
  }

  changeThemeAfterBuild(BuildContext context) {
    if ((CustomTheme.instanceOf(context).themeData.primaryColor !=
        this.widget.screenDefaultTheme.primaryColor) && ModalRoute.of(context).isCurrent)
        CustomTheme.instanceOf(context)
          .changeTheme(this.widget.screenDefaultTheme);
  }
}
