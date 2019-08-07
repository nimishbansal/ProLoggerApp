import 'dart:async';

import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';

class LogEntryDetailBloc {
  LogEntry logEntry = LogEntry(
      id: null, logLevel: null, title: null, created_at: null, message: null);
  LogEntryRepository _logEntryRepository;

  StreamController<LogEntry> _issueDetailStateController =
      StreamController<LogEntry>();
  Stream<LogEntry> get logEntryDetailStream =>
      _issueDetailStateController.stream;

  LogEntryDetailBloc() {
    _logEntryRepository = new LogEntryRepository();
  }

  void displayResults(int id) async {
    LogEntry entry = await _logEntryRepository.fetchLogEntryDetails(id);
    _issueDetailStateController.add(entry);
  }

  void dispose() {
    _issueDetailStateController.close();
  }
}
