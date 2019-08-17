import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pro_logger/Entries/Events/issue_events.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:web_socket_channel/io.dart';

class LogEntryListBloc {
  LogEntry logEntry = new LogEntry(
      id: null, title: null, message: null, logLevel: null, created_at: null);

  List<LogEntry> logEntries;
  LogEntryRepository _logEntryRepository;

  WebSocket _webSocket;
  IOWebSocketChannel _ioWebSocketChannel;

  StreamController<List<LogEntry>> _issueListStateController =
      StreamController<List<LogEntry>>();
//  https://stackoverflow.com/a/51397263/7698247
  StreamSink<List<LogEntry>> get inIssue => _issueListStateController.sink;
  Stream<List<LogEntry>> get logEntryStream => _issueListStateController.stream;

  final _logEntryEventController = StreamController<LogEntryEvent>();
  Sink<LogEntryEvent> get logEventControllerSink =>
      _logEntryEventController.sink;

  LogEntryListBloc() {
    _logEntryRepository = new LogEntryRepository();
    this.fetchLogEntriesList();
    this.connectToSocket();
    this._logEntryEventController.stream.listen(_mapEventToState);
  }

  void fetchLogEntriesList() async {
    this.logEntries = await _logEntryRepository.fetchLogEntryList();
    this._issueListStateController.add(logEntries);
  }

  void connectToSocket() async {
    this._webSocket = await WebSocket.connect("ws://192.168.0.107:8080/",
        protocols: ['echo-protocol']);
    this._ioWebSocketChannel = IOWebSocketChannel(_webSocket);
    this._ioWebSocketChannel.sink.add(json.encode({'type': 'onConnect'}));
    this._ioWebSocketChannel.stream.listen((dynamic data) {
      this.logEntry = LogEntry.fromJson(json.decode(data.toString()));
      this.logEventControllerSink.add(NewLogEntryEvent());
    });
  }

  void _mapEventToState(LogEntryEvent event) {
    if (event is NewLogEntryEvent) {
      this.logEntries.length += 1;
      this.logEntries.setRange(1, logEntries.length, logEntries);
      this.logEntries.setRange(0, 1, [logEntry]);
      this.inIssue.add(logEntries);
    }
  }

  void dispose() {
    _logEntryEventController.close();
    _issueListStateController.close();
    _ioWebSocketChannel.sink.close();
    _webSocket.close();
  }
}

final logEntryListBloc = LogEntryListBloc();
