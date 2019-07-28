import 'package:meta/meta.dart';
import 'package:pro_logger/utility/LogLevel.dart';

class LogEntry
{
	String title;
	String message;
	LogLevel logLevel;
	
	LogEntry({@required this.title, @required this.message, @required this.logLevel})
	{
		this.title = title;
		this.message = message;
		this.logLevel = logLevel;
	}

	LogEntry.fromJson(Map<String, dynamic> data)
	{
		title = data['title'];
		message = data['message'];
		logLevel = LogLevel.fromLevelName(data['level_name']);
	}

	@override
	String toString()
	{
		return this.title;
	}
	
}