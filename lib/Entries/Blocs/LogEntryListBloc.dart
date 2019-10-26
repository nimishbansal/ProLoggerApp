import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tuple/tuple.dart';
import 'package:pro_logger/Entries/Events/issue_events.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:web_socket_channel/io.dart';
import 'package:pro_logger/utility/network_utils.dart';

class LogEntryListBloc {
  LogEntry logEntry = new LogEntry(
      id: null, title: null, message: null, logLevel: null, created_at: null);

  int noOfRecords = 0;
  static const int pageSize = 10;

  get lastPage {
    return (noOfRecords / pageSize).ceil();
  }

  int pageNo = 1;

  List<LogEntry> logEntries;
  List<Tuple2<LogEntry, bool>> logEntriesSelectedStatus =
      new List<Tuple2<LogEntry, bool>>();
  LogEntryRepository _logEntryRepository;

  WebSocket _webSocket;
  IOWebSocketChannel _ioWebSocketChannel;

  StreamController<ApiResponse> _logEntryListStateController =
      StreamController<ApiResponse>();

//  https://stackoverflow.com/a/51397263/7698247
  StreamSink<ApiResponse> get inIssue => _logEntryListStateController.sink;
  Stream<ApiResponse> get logEntryStream => _logEntryListStateController.stream;

  final _logEntryEventController = StreamController<LogEntryEvent>();
  Sink<LogEntryEvent> get logEventControllerSink =>
      _logEntryEventController.sink;

  LogEntryListBloc() {
    _logEntryRepository = new LogEntryRepository();
    this.fetchLogEntriesList(pageNo: 1);
    this.connectToSocket();
    this._logEntryEventController.stream.listen(_mapEventToState);
  }

  void fetchLogEntriesList({int pageNo}) async {
    this.pageNo = pageNo;
    _logEntryListStateController.add(ApiResponse.loading(message:'Page${this.pageNo}'));
    try {
      var result = await _logEntryRepository.fetchLogEntryList(pageNo: pageNo);
      logEntries = result.item1;
      noOfRecords = result.item2;
      logEntriesSelectedStatus = logEntries
          .map((currentLogEntry) => Tuple2(currentLogEntry, false))
          .toList();
      _logEntryListStateController
          .add(ApiResponse.completed(logEntriesSelectedStatus));
    } catch (e) {
      if (e.runtimeType == SocketException) {
        _logEntryListStateController
            .add(ApiResponse.error('Connection Refused'));
      }
    }
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
    if (event is NewLogEntryEvent) { // New issue event
      noOfRecords++;
      if (this.pageNo == 1) {
        if (logEntriesSelectedStatus.length < pageSize) {
          this.logEntriesSelectedStatus.length += 1;
        }
        this.logEntriesSelectedStatus.setRange(
            1, this.logEntriesSelectedStatus.length, logEntriesSelectedStatus);
        this.logEntriesSelectedStatus.setRange(0, 1, [Tuple2(logEntry, false)]);
        this.inIssue.add(ApiResponse.completed(this.logEntriesSelectedStatus));
      }
    } else if (event is LogEntryCheckBoxToggledEvent) { // Log Entry List Item Selected
      var previousTuple = this.logEntriesSelectedStatus[event.index];
      this.logEntriesSelectedStatus[event.index] = Tuple2(previousTuple.item1, !previousTuple.item2);
      this.inIssue.add(ApiResponse.completed(this.logEntriesSelectedStatus));
    }
  }

  void dispose() {
    _logEntryEventController.close();
    _logEntryListStateController.close();
    _ioWebSocketChannel.sink.close();
    _webSocket.close();
  }
}

final logEntryListBloc = LogEntryListBloc();
