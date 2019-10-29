import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Blocs/LogEntryDetailBloc.dart';

import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';
import 'package:pro_logger/utility/LogLevel.dart';
import 'LevelSpecificLogEntryDetailScreen.dart';

//https://stackoverflow.com/questions/54101589/navigating-to-a-new-screen-when-stream-value-in-bloc-changes

class LogEntryDetailScreen extends StatefulWidget {
  final String title;
  final String message;
  final LogEntry logEntry;
  final int id;
  final int projectId;

  LogEntryDetailScreen(
      {Key key,
      @required this.id,
      this.title,
      this.message,
      this.projectId,
      @required this.logEntry})
      : super(key: key);

  @override
  _LogEntryDetailScreenState createState() => _LogEntryDetailScreenState();
}

class _LogEntryDetailScreenState extends State<LogEntryDetailScreen> {
  StreamSubscription _streamSubscription;
  LogEntryDetailBloc _logEntryDetailBloc;
  var toDelete = false;

  void _listen() {
    _streamSubscription =
        _logEntryDetailBloc.logEntryDeleteStream.listen((value) {
      if (value) {
        Navigator.pop(context, "RECORD_DELETED");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _logEntryDetailBloc = LogEntryDetailBloc();
    _logEntryDetailBloc.displayResults(this.widget.id, widget.projectId);
    _listen();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        print("cancel");
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        print("continue");
        _logEntryDetailBloc.deleteLogEntry(this.widget.id);
        this.setState(() {
          toDelete = true;
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Are you sure you dont want to delete this log entry?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => changeThemeAfterBuild(context));

//    if (toDelete) deleteLogEntry();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
//            _logEntryDetailBloc.dispose();
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showAlertDialog(context);
            },
          )
        ],
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
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                            stream: _logEntryDetailBloc.logEntryDetailStream,
                            builder: (context, snapshot) {
                              print("has detail data ${snapshot.hasData}");
                              print(snapshot.data);
                              if (snapshot.hasData) {
                                var logEntry = (snapshot.data as LogEntry);
                                if (logEntry.logLevel.name == ERROR)
                                  return Container(
                                    child: ErrorDetailScreenContainer(
                                      logEntry: logEntry,
                                    ),
                                    height: MediaQuery.of(context).size.height -
                                        110,
                                  );

                                return Container(
                                    child: Text(snapshot.data.toString()),
                                    height: MediaQuery.of(context).size.height -
                                        200);
                              } else {
                                return new Image(
                                    image: new AssetImage("images/loader.gif"));
                              }
                            }),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 50,
                    width: 220,
                    height: 200,
                    child: Container(
                      child: toDelete
                          ? AlertDialog(
                              title: Text("\tDeleting"),
                              content: Column(
                                children: [CircularProgressIndicator()],
                              ))
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                    ),
                  ),
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

  void deleteLogEntry() async {
    Future.delayed(const Duration(milliseconds: 3500), () {
      setState(() {
        toDelete = false;
        Navigator.pop(context);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }
}
