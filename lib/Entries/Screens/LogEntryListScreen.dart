import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Blocs/LogEntryListBloc.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/Entries/widgets/loader.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';
import 'package:pro_logger/Entries/widgets/LogEntryCard.dart';
import 'package:pro_logger/utility/LogLevel.dart';
import 'package:pro_logger/utility/network_utils.dart';
import 'package:tuple/tuple.dart';

class LogEntryListScreen extends StatefulWidget {
  final int projectId;
  final String title;
  LogEntryListScreen({Key key, this.title, this.projectId}) : super(key: key);

  final ThemeData screenDefaultTheme = ThemeData(primaryColor: white);

  @override
  _LogEntryListScreenState createState() => _LogEntryListScreenState();
}

class _LogEntryListScreenState extends State<LogEntryListScreen> {
  LogEntryListBloc logEntryListBloc;

  @override
  void initState() {
    super.initState();
    logEntryListBloc = LogEntryListBloc();
    logEntryListBloc.fetchLogEntriesList(
        pageNo: 1, projectId: widget.projectId);
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
            Navigator.of(context).pop();
          },
        ),
        title: Text("Issues"),
        actions: <Widget>[
          Padding(
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      LogEntryListBloc _deletelogEntriesListBloc =
                          LogEntryListBloc(connectToSocket: false);
                      return StreamBuilder<ApiResponse>(
                          stream:
                              _deletelogEntriesListBloc.deleteLogEntriesStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data.status == Status.COMPLETED) {
                              _deletelogEntriesListBloc.deleteLogEntriesSink
                                  .add(ApiResponse.halt());
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.of(context).pop();
                                logEntryListBloc.fetchLogEntriesList(
                                    pageNo: logEntryListBloc.pageNo,
                                    projectId: widget.projectId);
                              });
                            }
                            bool _isLoading = snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data.status == Status.LOADING;
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Are your sure you want to delete selected log entries?',
                                  ),
                                  _isLoading
                                      ? Loader()
                                      : SizedBox(
                                          height: 0,
                                        ),
                                ],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                    List<Tuple2<LogEntry, bool>> selectedLogEntries = logEntryListBloc.logEntriesSelectedStatus.where((Tuple2<LogEntry, bool>tup) {
                                      return tup.item2;
                                    }).toList();
                                          _deletelogEntriesListBloc.deleteLogEntries(selectedLogEntries, widget.projectId);
                                        },
                                ),
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          Navigator.of(context).pop();
                                        },
                                ),
                              ],
                            );
                          });
                    });
              },
            ),
            padding: EdgeInsets.only(right: 20),
          ),
        ],
      ),
      body: StreamBuilder<ApiResponse>(
        stream: logEntryListBloc.logEntryStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              (snapshot.hasData && snapshot.data.status == Status.LOADING)) {
            return Center(
                child: Image(image: new AssetImage("images/loader.gif")));
          } else if (snapshot.hasData && snapshot.data.status == Status.ERROR) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    'https://static.thenounproject.com/png/207492-200.png',
                    width: 50,
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  Text(snapshot.data.message)
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: _myListView(context, snapshot.data.data),
                  height: MediaQuery.of(context).size.height - 136,
                ),
                BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          child: Icon(Icons.chevron_left),
                          onPressed: (logEntryListBloc.pageNo == 1)
                              ? null
                              : _handleLeftButtonPressed),
                      FlatButton(
                          child: Icon(Icons.chevron_right),
                          onPressed: (logEntryListBloc.pageNo ==
                                  logEntryListBloc.lastPage)
                              ? null
                              : _handleRightButtonPressed)
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _myListView(BuildContext context,
      List<Tuple2<LogEntry, bool>> logEntriesSelectedStatus) {
    return ListView.builder(
      itemCount: logEntriesSelectedStatus.length,
      itemBuilder: (context, index) {
        LogEntry logEntry = logEntriesSelectedStatus[index].item1;
        return LogEntryCard(
            projectId: widget.projectId,
            logEntryListBloc: logEntryListBloc,
            key: ValueKey(logEntry),
            index: index);
      },
    );
  }

  changeThemeAfterBuild(BuildContext context) {
    if ((CustomTheme.instanceOf(context).themeData.primaryColor !=
            this.widget.screenDefaultTheme.primaryColor) &&
        ModalRoute.of(context).isCurrent)
      CustomTheme.instanceOf(context)
          .changeTheme(this.widget.screenDefaultTheme);
  }

  void _handleLeftButtonPressed() {
    logEntryListBloc.fetchLogEntriesList(
        pageNo: logEntryListBloc.pageNo - 1, projectId: widget.projectId);
  }

  void _handleRightButtonPressed() {
    logEntryListBloc.fetchLogEntriesList(
        pageNo: logEntryListBloc.pageNo + 1, projectId: widget.projectId);
  }

  @override
  void dispose() {
      logEntryListBloc.dispose();
    super.dispose();
  }
}
