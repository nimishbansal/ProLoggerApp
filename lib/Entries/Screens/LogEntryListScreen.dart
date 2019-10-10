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
                  (snapshot.hasData &&
                      snapshot.data.status == Status.LOADING)) {
                print("snapshot data is ${snapshot.data}");
                return Image(image: new AssetImage("images/loader.gif"));
              } else {
                print("snapshot data is ${snapshot.data}");
                return Container(child: _myListView(context, snapshot.data.data),);
              }
            }));
  }

  Widget _myListView(BuildContext context,   List<Tuple2<LogEntry, bool>> logEntriesSelectedStatus) {
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
}
