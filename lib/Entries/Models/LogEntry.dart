import 'package:meta/meta.dart';
import 'package:pro_logger/utility/LogLevel.dart';

class LogEntry {
  int id;
  String title;
  String message;
  LogLevel logLevel;
  DateTime created_at;

  LogEntry(
      {@required this.id,
      @required this.title,
      @required this.message,
      @required this.logLevel,
      // ignore: non_constant_identifier_names
      DateTime created_at}) {
    this.title = title;
    this.message = message;
    this.logLevel = logLevel;
  }

  LogEntry.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    message = data['message'];
    logLevel = LogLevel.fromLevelName(data['level_name']);
    var created_at_json = data['created_at'];
    if (created_at_json != null) {
      created_at = DateTime(
          created_at_json['year'],
          created_at_json['month'],
          created_at_json['day'],
          created_at_json['minute'],
          created_at_json['second']);
    }
  }

  @override
  String toString() {
    return this.title + "(${this.id.toString()})";
  }
}
