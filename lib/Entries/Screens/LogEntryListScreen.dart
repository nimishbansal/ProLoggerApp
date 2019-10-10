import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Blocs/LogEntryListBloc.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';
import 'package:pro_logger/Entries/widgets/LogEntryCard.dart';
import 'package:pro_logger/utility/LogLevel.dart';
import 'package:pro_logger/utility/network_utils.dart';
import 'package:tuple/tuple.dart';

class LogEntryListScreen extends StatefulWidget {
  final String title;
  LogEntryListScreen({Key key, this.title}) : super(key: key);

  final ThemeData screenDefaultTheme = ThemeData(primaryColor: white);

  @override
  _LogEntryListScreenState createState() => _LogEntryListScreenState();
}

class _LogEntryListScreenState extends State<LogEntryListScreen> {
  @override
  void initState() {
    super.initState();
    logEntryListBloc.fetchLogEntriesList(pageNo: 1);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => changeThemeAfterBuild(context));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        title: Text("Issues"),
      ),
      body: StreamBuilder<ApiResponse>(
        stream: logEntryListBloc.logEntryStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              (snapshot.hasData && snapshot.data.status == Status.LOADING)) {
            print("snapshot data is ${snapshot.data}");
            return Center(child: Image(image: new AssetImage("images/loader.gif")));
          } else {
            print("snapshot data is ${snapshot.data}");
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: _myListView(context, snapshot.data.data),
                  height: MediaQuery.of(context).size.height-130,
                ),
                BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.chevron_left),
                        onPressed: (logEntryListBloc.pageNo == 1)?null: _handleLeftButtonPressed
                      ),
                      FlatButton(
                        child: Icon(Icons.chevron_right),
                        onPressed: (logEntryListBloc.pageNo == logEntryListBloc.lastPage)?null: _handleRightButtonPressed
                      )
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
          key: ValueKey(logEntry),
          logEntry: logEntry,
        );
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
    logEntryListBloc.fetchLogEntriesList(pageNo: logEntryListBloc.pageNo-1);
  }
  void _handleRightButtonPressed() {
    logEntryListBloc.fetchLogEntriesList(pageNo: logEntryListBloc.pageNo+1);
  }
}
