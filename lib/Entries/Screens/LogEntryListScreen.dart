
import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Blocs/LogEntryListBloc.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';
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
  LogEntryListBloc _logEntryBloc;

  @override
  void initState() {
    super.initState();
    _logEntryBloc = new LogEntryListBloc();
    _logEntryBloc.fetchLogEntriesList();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                stream: _logEntryBloc.logEntryStream,
                builder: (context, snapshot) {
//                  print("has data ${snapshot.hasData}");
//                  print("data ${snapshot.data}");

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

  changeThemeAfterBuild(BuildContext context) {
    if ((CustomTheme.instanceOf(context).themeData.primaryColor !=
        this.widget.screenDefaultTheme.primaryColor) && ModalRoute.of(context).isCurrent)
        CustomTheme.instanceOf(context)
          .changeTheme(this.widget.screenDefaultTheme);
  }
}
