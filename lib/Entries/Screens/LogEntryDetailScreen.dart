import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_logger/Entries/Blocs/LogEntryDetailBloc.dart';

import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';
import 'package:pro_logger/utility/LogLevel.dart';

/// It s a widget to display one frame of exception stack trace
class StackTraceFrameTile extends StatefulWidget {
  final int exceptionLineNo;
  final String fileName;
  final String functionName;
  final String preContextText;
  final String exceptionContextText;
  final String postContextText;

  const StackTraceFrameTile(
      {Key key,
      this.exceptionLineNo,
      this.fileName,
      this.functionName,
      this.preContextText,
      this.exceptionContextText,
      this.postContextText})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return StackTraceFrameTileState();
  }
}

class StackTraceFrameTileState extends State<StackTraceFrameTile> {
  var collapsed = true;

  toggleCollapse() {
    this.setState(() {
      collapsed = !(collapsed);
    });
  }

  @override
  Widget build(BuildContext context) {
    var completeLine =
        '${widget.fileName} in ${widget.functionName} at line ${widget.exceptionLineNo}';

    var textWidget = Expanded(
        child: Container(
      child: Text(
        completeLine,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      color: Color(0xececf1).withAlpha(0xFF),
      margin: EdgeInsets.all(4),
    ));

    var plusMinusIcon = Icons.remove;
    if (collapsed) plusMinusIcon = Icons.add;

    var plusMinusButton = IconButton(
        onPressed: () {
          toggleCollapse();
        },
        icon: Container(
            decoration: new BoxDecoration(
                border: new Border.all(color: Colors.grey),
                color: Color(0xFFFFFF).withAlpha(0xFF)),
            child: Icon(
              plusMinusIcon,
              color: Colors.grey,
            )));

    var groupTextWidgetAndExpandButton = GestureDetector(
      child: Container(
          decoration: BoxDecoration(
              color: Color(0xececf1).withAlpha(0xFF),
              border: Border.all(width: 0.6, color: Colors.grey[500])),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[textWidget, plusMinusButton])),
      onTap: () {
        toggleCollapse();
      },
    );

    var expandedDetails;
    if (collapsed) {
      expandedDetails = Container();
    } else {
      expandedDetails = Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.preContextText.trimRight(),
              style: TextStyle(height: 1.2, fontSize: 15),
            ),
            Container(
              child: Text(
                widget.exceptionContextText.trimRight(),
                style:
                    TextStyle(color: Colors.white, height: 1.2, fontSize: 15),
              ),
              color: Colors.redAccent,
//              color: Color(0x6c5fc7).withAlpha(0xFFFFF),
              width: double.infinity,
            ),
            Text(widget.postContextText.trimRight(),
                style: TextStyle(height: 1.2, fontSize: 15))
          ],
        ),
      );
    }
    var finalColumn = Column(
      children: <Widget>[groupTextWidgetAndExpandButton, expandedDetails],
    );
    return finalColumn;
  }
}

/// It is a ListView Widget that display all the details of LogEntry including
/// timestamp, message, exception stacktrace, tags etc.
class LogEntryDetailListViewComponent extends StatefulWidget {
  final LogEntry logEntry;

  const LogEntryDetailListViewComponent({Key key, this.logEntry})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LogEntryDetailListViewComponentState();
  }
}

class LogEntryDetailListViewComponentState
    extends State<LogEntryDetailListViewComponent> {

    bool get _showExceptionStackTrace {
       return widget.logEntry.stacktrace != null;
    }

  @override
  Widget build(BuildContext context) {
    List<Widget> exceptionStackTracesTiles = [];
    if (_showExceptionStackTrace) {
      widget.logEntry.stacktrace['frames_data'].forEach((currentMap) {
        List<String> previousLines = [];
        List<String> nextLines = [];
        (currentMap['previous_lines'] as List<dynamic>).forEach((dynamic p) {
          previousLines.add(p);
        });
        (currentMap['next_lines'] as List<dynamic>).forEach((dynamic p) {
          nextLines.add(p);
        });
        exceptionStackTracesTiles.add(
          StackTraceFrameTile(
            functionName: currentMap['function_name'],
            exceptionLineNo: currentMap['line_no'],
            fileName: currentMap['filepath'],
            preContextText: previousLines.join(),
            exceptionContextText: currentMap['code_line'],
            postContextText: nextLines.join(),
          ),
        );
      });
    }
    // reverse stack tiles to show the recent first
    exceptionStackTracesTiles = exceptionStackTracesTiles.reversed.toList();

    List<Widget> frames = [
      // Title
      new Text(
        'Title:',
        style: TextStyle(fontSize: 22, color: Color.fromRGBO(127, 127, 127, 1)),
      ),
      new Text(
        widget.logEntry.title.toString(),
        style: TextStyle(fontSize: 20),
      ),
      Padding(
        padding: EdgeInsets.all(4),
      ),

      Divider(
        color: Colors.grey[500],
      ),

      //Message
      new Text(
        'Message:',
        style: TextStyle(fontSize: 22, color: Color.fromRGBO(127, 127, 127, 1)),
      ),
      new Text(
        widget.logEntry.message.toString(),
        style: TextStyle(fontSize: 20),
      ),
      Padding(
        padding: EdgeInsets.all(4),
      ),

      Divider(
        color: Colors.grey[500],
      ),


      // Exception Stack Trace
      _showExceptionStackTrace?Align(
        alignment: Alignment.centerLeft,
        child: new Text(
          'Exception:',
          style: TextStyle(
            fontSize: 22,
            color: Color.fromRGBO(127, 127, 127, 1),
          ),
        ),
      ):SizedBox(height: 0,width: 0,),
    ];

    if (_showExceptionStackTrace && exceptionStackTracesTiles.length != 0) {
      frames.addAll(exceptionStackTracesTiles);
    }

    frames.addAll([
      Padding(
        padding: EdgeInsets.all(4),
      ),

      _showExceptionStackTrace?Divider(
        color: Colors.grey[500],
      ):SizedBox(height: 0,width: 0,),

      // Timestamp
      new Text(
        'Timestamp:',
        style: TextStyle(fontSize: 22, color: Color.fromRGBO(127, 127, 127, 1)),
      ),

      new Text(
        DateFormat("MMM d, y hh:mm:ss").format(widget.logEntry.createdAt),
        style: TextStyle(fontSize: 20),
      ),

      Divider(
        color: Colors.grey[500],
      ),

      new Text(
        'Tags:',
        style: TextStyle(fontSize: 22, color: Color.fromRGBO(127, 127, 127, 1)),
      ),

      new Builder(builder: (BuildContext context) {
        return GridView.count(
            primary: false, // set false to disallow scrolling inside grid view
            crossAxisCount: 2,
            mainAxisSpacing: 0.1,
            childAspectRatio: 3,
            shrinkWrap: true,
            children: widget.logEntry.tags.entries
                .map(
                  (mapEntry) => GridTile(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            mapEntry.key,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.pink,
                            ),
                          ),
                          Text(" : ", style: TextStyle(fontSize: 22)),
                          Text(
                            mapEntry.value.toString(),
                            style: TextStyle(fontSize: 22, color: blue),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList());
      }),

      Divider(
        color: Colors.grey[500],
      ),
    ]);
    return ListView(
      shrinkWrap: true,
      children: frames,
    );
  }
}

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

  showDeleteLogEntryAlertDialog(BuildContext context) {
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
        _logEntryDetailBloc.deleteLogEntry(
            this.widget.id, this.widget.projectId);
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
              showDeleteLogEntryAlertDialog(context);
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
                                return Container(
                                  child: LogEntryDetailListViewComponent(
                                    logEntry: logEntry,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height - 110,
                                );
                              } else {
                                return new Image(
                                    image: new AssetImage("images/loader.gif"));
                              }
                            }),
                      ],
                    ),
                  ),

                  // Delete Dialog
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
