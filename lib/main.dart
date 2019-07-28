import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Screens/LogEntryListScreen.dart';
import 'package:pro_logger/utility/LogLevel.dart';

void main() => runApp(MyApp());

class Choice
{
	final title,icon;
	
	const Choice({this.title, this.icon});
}


class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter Demo',
			theme: ThemeData(
				primaryColor:white
			),
			home: LogEntryListScreen(),
		);
	}
}
