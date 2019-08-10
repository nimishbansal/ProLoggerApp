import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Blocs/LogEntryDetailBloc.dart';

import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';
import 'package:pro_logger/utility/LogLevel.dart';
import '../../main.dart';
import 'LevelSpecificLogEntryDetailScreen.dart';

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
    print('building');
    WidgetsBinding.instance
        .addPostFrameCallback((_) => changeThemeAfterBuild(context));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            _logEntryDetailBloc.dispose();
            Navigator.pop(context);
          },
        ),
        title: Text(this.widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: new Material(
                child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                width: MediaQuery.of(context).size.width-20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    new Text(
                      'Message:',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(127, 127, 127, 1)),
                    ),
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
                            var logEntry = (snapshot.data as LogEntry);
                            if (logEntry.logLevel.name == ERROR)
                              return ErrorDetailScreenContainer();

                            return Container(
                                child: Text(snapshot.data.toString()),
                                height:
                                    MediaQuery.of(context).size.height - 200);
                          } else {
                            return new Image(
                                image: new AssetImage("images/loader.gif"));
                          }
                        }),
                  ],
                ),
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
