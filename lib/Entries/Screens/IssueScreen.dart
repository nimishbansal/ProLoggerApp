import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Blocs/IssueBloc.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:pro_logger/LogEntry.dart';
import 'package:pro_logger/main.dart';
import 'package:pro_logger/utility/LogLevel.dart';
import 'package:pro_logger/widgets/LogEntryCard.dart';
import 'package:requests/requests.dart';

class IssueScreen extends StatefulWidget {
	final String title;
	IssueScreen({Key key, this.title}) : super(key: key);

	@override
	_IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {

	var logEntries = List<LogEntry>();
	var dataLoaded = false;

	@override
	void initState() {
		super.initState();
		LogEntryRepository repository = new LogEntryRepository();
		getLogEntries(repository);
	}

	void getLogEntries(LogEntryRepository repository) async
	{
		var entries = await repository.fetchLogEntryList();
		setState((){
			logEntries.addAll(entries);
		});
//		var logEntry1 = LogEntry(title: "Title", message: "This is a custom message", logLevel: notset);
//		var logEntry2 = LogEntry(title: "Title", message: "This is a custom message", logLevel: debug);
//		var logEntry3 = LogEntry(title: "Title", message: "This is a custom message", logLevel: info);
//		var logEntry4 = LogEntry(title: "Title", message: "This is a custom message", logLevel: warning);
//		var logEntry5 = LogEntry(title: "Title", message: "This is a custom message", logLevel: error);
//		var logEntry6 = LogEntry(title: "Title", message: "This is a custom message", logLevel: fatal);
//		var logEntry7 = LogEntry(title: "Title", message: "This is a custom message", logLevel: critical);

//		logEntries.addAll([logEntry1,logEntry2, logEntry3, logEntry4, logEntry5, logEntry6, logEntry7]);

	}


	@override
	Widget build (BuildContext context)
	{
			const List<Choice> choices = const <Choice>[
			const Choice(title: 'Car', icon: Icons.directions_car),
			const Choice(title: 'Bicycle', icon: Icons.directions_bike),
			const Choice(title: 'Boat', icon: Icons.directions_boat)
		];
		return Scaffold(
			appBar: AppBar(
				leading: IconButton(icon:Icon(Icons.arrow_back_ios), onPressed: () {},),
				title: Text("Issues"),
				actions: <Widget>[
					Builder(builder: (context) =>
							PopupMenuButton<Choice>(
								onSelected: (choice) => _select(choice, context),
								itemBuilder: (BuildContext context) {
									return choices.map((Choice choice) {
										return PopupMenuItem<Choice>(
											value: choice,
											child: Text(choice.title),
										);
									}).toList();
								},
							),
					),
				],
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Container(child: _myListView(context), height:  MediaQuery.of(context).size.height-100,)
					],
				),
			),
		);
	}


	Widget _myListView(BuildContext context) {
		return ListView.builder(
			itemCount: logEntries.length,
			itemBuilder: (context, index) {
				return LogEntryCard(logEntry: logEntries[index],);
			},
		);

	}


	void _select(Choice value, BuildContext context) {
		Scaffold.of(context).hideCurrentSnackBar();
		Scaffold.of(context).showSnackBar(new SnackBar(
			content: new Text(value.title + " selected"),
		));
	}

}
