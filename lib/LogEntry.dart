import 'package:meta/meta.dart';
import 'package:pro_logger/utility/logging_utils.dart';

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
	
}