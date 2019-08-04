import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Screens/LogEntryDetailScreen.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';

class LogEntryCard extends StatefulWidget {
  final LogEntry logEntry;

  LogEntryCard({Key key, this.logEntry}) : super(key: key);

  @override
  _LogEntryCardState createState() => _LogEntryCardState(this.logEntry);
}

class _LogEntryCardState extends State<LogEntryCard> {
  final LogEntry logEntry;
  var checkboxStatus = false;

  _LogEntryCardState(this.logEntry);

  Widget getLogEntryCard() {
    return new Container(
      child: new Card(
        child: InkWell(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading:
                      getColoredIconForLogLevel(color: logEntry.logLevel.color),
                  title: Text('${logEntry.title}'),
                  subtitle: Text('${logEntry.message}'),
                  trailing: Checkbox(
                    value: checkboxStatus,
                    onChanged: (bool value) {
                      setState(() {
                        checkboxStatus = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return LogEntryDetailScreen(
                      id: logEntry.id,
                      title: logEntry.title,
                      message: logEntry.message,
                      logEntry: logEntry
                    );
                  },
                ),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getLogEntryCard();
  }

  Widget getColoredIconForLogLevel({Color color}) {
    return CircleAvatar(
      backgroundColor: color,
    );
  }
}
