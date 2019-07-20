import 'package:flutter/material.dart';
import 'package:pro_logger/LogEntry.dart';
import 'package:pro_logger/main.dart';
import 'package:pro_logger/utility/logging_utils.dart';
import 'package:pro_logger/widgets/LogEntryCard.dart';

class IssueScreen extends StatefulWidget {
	final String title;
	IssueScreen({Key key, this.title}) : super(key: key);
	@override
	_IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
	
	@override
	Widget build(BuildContext context) {
		// This method is rerun every time setState is called, for instance as done
		// by the _incrementCounter method above.
		//
		// The Flutter framework has been optimized to make rerunning build methods
		// fast, so that you can just rebuild anything that needs updating rather
		// than having to individually change instances of widgets.
		
		
		const List<Choice> choices = const <Choice>[
			const Choice(title: 'Car', icon: Icons.directions_car),
			const Choice(title: 'Bicycle', icon: Icons.directions_bike),
			const Choice(title: 'Boat', icon: Icons.directions_boat)
		];
		
		return Scaffold(
			appBar: AppBar(
				// Here we take the value from the MyHomePage object that was created by
				// the App.build method, and use it to set our appbar title.
				title: Text(widget.title),
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
				// Center is a layout widget. It takes a single child and positions it
				// in the middle of the parent.
				child: Column(
					// Column is also layout widget. It takes a list of children and
					// arranges them vertically. By default, it sizes itself to fit its
					// children horizontally, and tries to be as tall as its parent.
					//
					// Invoke "debug painting" (press "p" in the console, choose the
					// "Toggle Debug Paint" action from the Flutter Inspector in Android
					// Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
					// to see the wireframe for each widget.
					//
					// Column has various properties to control how it sizes itself and
					// how it positions its children. Here we use mainAxisAlignment to
					// center the children vertically; the main axis here is the vertical
					// axis because Columns are vertical (the cross axis would be
					// horizontal).
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Container(child: _myListView(context), height:  MediaQuery.of(context).size.height-100,)
					],
				),
			),
		);
	}
	
	
	void _incrementCounter() {
		setState(() {
			// This call to setState tells the Flutter framework that something has
			// changed in this State, which causes it to rerun the build method below
			// so that the display can reflect the updated values. If we changed
			// _counter without calling setState(), then the build method would not be
			// called again, and so nothing would appear to happen.
//			_counter++;
		});
	}
	
	
	Widget _myListView(BuildContext context) {
		var logEntry1 = LogEntry(title: "Title", message: "This is a custom message", logLevel: notset);
		var logEntry2 = LogEntry(title: "Title", message: "This is a custom message", logLevel: debug);
		var logEntry3 = LogEntry(title: "Title", message: "This is a custom message", logLevel: info);
		var logEntry4 = LogEntry(title: "Title", message: "This is a custom message", logLevel: warning);
		var logEntry5 = LogEntry(title: "Title", message: "This is a custom message", logLevel: error);
		var logEntry6 = LogEntry(title: "Title", message: "This is a custom message", logLevel: fatal);
		var logEntry7 = LogEntry(title: "Title", message: "This is a custom message", logLevel: critical);
		var logEntry8 = LogEntry(title: "Title", message: "This is a custom message", logLevel: critical);
		var logEntry9 = LogEntry(title: "Title", message: "This is a custom message", logLevel: critical);
		
		var logEntries = List<LogEntry>();
		logEntries.addAll([logEntry1,logEntry2, logEntry3, logEntry4, logEntry5, logEntry6, logEntry7, logEntry8, logEntry9]);
		
		return ListView.builder(
			itemCount: logEntries.length,
			itemBuilder: (context, index) {
				return LogEntryCard(logEntry: logEntries[index],);
			},
		);
		
	}
	
	
	void _select(Choice value, BuildContext context) {
		print(value.title);
		Scaffold.of(context).hideCurrentSnackBar();
		Scaffold.of(context).showSnackBar(new SnackBar(
			content: new Text(value.title + " selected"),
		));
	}
	
}
