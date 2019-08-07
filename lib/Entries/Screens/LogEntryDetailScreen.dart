import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Blocs/LogEntryDetailBloc.dart';

import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';
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
  LogEntryDetailBloc _logEntryDetailBloc;

  @override
  void initState() {
    super.initState();
    _logEntryDetailBloc = LogEntryDetailBloc();
    _logEntryDetailBloc.displayResults(this.widget.id);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => changeThemeAfterBuild(context));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(this.widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Material(
                child: Container(
              child: Column(
                children: <Widget>[
                  new Text(
                    widget.logEntry.message,
                    style: TextStyle(fontSize: 20),
                  ),
                  StreamBuilder(
                          stream: _logEntryDetailBloc.logEntryDetailStream,
                          builder: (context, snapshot) {
                            print("has detail data ${snapshot.hasData}");
                            print(snapshot.data);
                            if (snapshot.hasData) {
                              return Container(
                                      child: Text(snapshot.data.toString()),
                                      height: MediaQuery.of(context).size.height - 200);
                            } else {
                              return new Image(image: new AssetImage("images/loader.gif"));
                            }
                          }),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

  changeThemeAfterBuild(BuildContext context) {
    if ((CustomTheme.instanceOf(context).themeData.primaryColor !=
            widget.logEntry.logLevel.color) &&
        ModalRoute.of(context).isCurrent)
      CustomTheme.instanceOf(context)
          .changeTheme(ThemeData(primaryColor: widget.logEntry.logLevel.color));
  }
}
