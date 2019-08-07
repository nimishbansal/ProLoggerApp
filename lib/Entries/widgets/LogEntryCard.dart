import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Screens/LogEntryDetailScreen.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:intl/intl.dart';

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
                  leading: getColoredIconForLogLevel(
                      color: logEntry.logLevel.color,
                      created_at: logEntry.created_at),
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
                        logEntry: logEntry);
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

  Widget getColoredIconForLogLevel({Color color, DateTime created_at}) {
    if (created_at == null) {
      print("created at is null");
      created_at = DateTime.now();
    }

    String formattedDate = DateFormat('kk:mm:ss').format(created_at);

    return Column(
      children: <Widget>[
          Padding(padding: EdgeInsets.all(3.0),),
          CircleAvatar(
            backgroundColor: color,
            maxRadius: 10,
          ),
        Padding(padding: EdgeInsets.all(2.0),),
        Text(formattedDate)
      ],
    );
  }
}
