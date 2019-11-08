import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pro_logger/utility/LogLevel.dart';

class LogEntry {
  int id;
  String title;
  String message;
  LogLevel logLevel;
  DateTime createdAt;
  Map<String, dynamic> tags;

  Map<String, dynamic> stacktrace;

  LogEntry(
      {@required this.id,
      @required this.title,
      @required this.message,
      @required this.logLevel,
      // ignore: non_constant_identifier_names
      DateTime created_at,
      dynamic tags}) {
    this.title = title;
    this.message = message;
    this.logLevel = logLevel;
  }

  LogEntry.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    message = data['message'];
    logLevel = LogLevel.fromLevelName(data['level_name']);
    var createdAtJson = data['created_at'];
    if (createdAtJson != null) {
      createdAt = DateTime(
          createdAtJson['year'],
          createdAtJson['month'],
          createdAtJson['day'],
          createdAtJson['hour'],
          createdAtJson['minute'],
          createdAtJson['second']);
    }
    tags = jsonDecode(jsonEncode(data['tags']));
    stacktrace = jsonDecode(jsonEncode(data['stacktrace']));
  }

  @override
  String toString() {
    return this.title + "(${this.id.toString()})";
  }
}
