import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Blocs/LogEntryListBloc.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:pro_logger/Entries/Screens/LogEntryDetailScreen.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:pro_logger/Entries/Events/issue_events.dart';

class LogEntryCard extends StatefulWidget {
  final int index;

  LogEntryCard({Key key, this.index}) : super(key: key);

  @override
  _LogEntryCardState createState() => _LogEntryCardState(logEntry:logEntryListBloc.logEntriesSelectedStatus[index].item1);
}

class _LogEntryCardState extends State<LogEntryCard> {
  final LogEntry logEntry;
  _LogEntryCardState({this.logEntry});

  Widget getLogEntryCard() {
    return new Container(
      child: new Card(
        child: InkWell(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: getColoredIconForLogLevel(
                      color: logEntry.logLevel.color,
                      created_at: logEntry.createdAt),
                  title: Text('${logEntry.title}'),
                  subtitle: Text('${logEntry.message}'),
                  trailing: Checkbox(
                    value: logEntryListBloc.logEntriesSelectedStatus[widget.index].item2,
                    onChanged: (_) {
                      logEntryListBloc.logEventControllerSink.add(LogEntryCheckBoxToggledEvent(index:widget.index));
                    },
                  ),
                ),
              ],
            ),
            onTap: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return LogEntryDetailScreen(
                        id: logEntry.id,
                        title: logEntry.title,
                        message: logEntry.message,
                        logEntry: logEntry);
                  },
                ),
              );
              if (result == "RECORD_DELETED") {
                logEntryListBloc.fetchLogEntriesList(pageNo:logEntryListBloc.pageNo);

              }
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getLogEntryCard();
  }

  Widget getColoredIconForLogLevel({Color color, DateTime created_at}) {
    if (created_at == null) {
      print("created at is null");
      created_at = DateTime.now();
    }

    String formattedDate = DateFormat('kk:mm:ss').format(created_at);

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(3.0),
        ),
        CircleAvatar(
          backgroundColor: color,
          maxRadius: 10,
        ),
        Padding(
          padding: EdgeInsets.all(2.0),
        ),
        Text(formattedDate)
      ],
    );
  }
}
