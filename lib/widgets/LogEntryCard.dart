import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_logger/LogEntry.dart';

class LogEntryCard extends StatefulWidget {
	final LogEntry logEntry;
	
	LogEntryCard({Key key, this.logEntry}) : super(key: key);
	
	@override
	_LogEntryCardState createState() => _LogEntryCardState(this.logEntry);
}

class _LogEntryCardState extends State<LogEntryCard> {
	final LogEntry logEntry;
	
	_LogEntryCardState(this.logEntry);
	
	Widget getLogEntryCard() {
		return
			new Container(
				child:
				new Card(child: Column(mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						ListTile(
							leading: get_colored_icon_for_log_level(color: logEntry.logLevel.color),
							title: Text('The ${logEntry.title}'),
							subtitle: Text('${logEntry.message}'),
						),
					],)
				),
			);
		
	}
	
	@override
	Widget build(BuildContext context) {
		return getLogEntryCard();
	}
	
	Widget get_colored_icon_for_log_level({Color color})
	{
		return CircleAvatar(
			backgroundColor: color,
		);
	}
}
