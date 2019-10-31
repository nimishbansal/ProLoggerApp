import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartis/dartis.dart';
import 'package:tuple/tuple.dart';
import 'package:pro_logger/Entries/Events/issue_events.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:web_socket_channel/io.dart';
import 'package:pro_logger/utility/network_utils.dart';
import 'package:pro_logger/globals.dart' as globals;

class LogEntryListBloc {
  LogEntry logEntry = new LogEntry(
      id: null, title: null, message: null, logLevel: null, created_at: null);

  int noOfRecords = 0;
  static const int pageSize = 10;

  get lastPage {
    if (noOfRecords == 0) return 1;
    return (noOfRecords / pageSize).ceil();
  }

  int pageNo = 1;

  List<LogEntry> logEntries;
  List<Tuple2<LogEntry, bool>> logEntriesSelectedStatus =
      new List<Tuple2<LogEntry, bool>>();
  LogEntryRepository _logEntryRepository;

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
    this.connectToRedis();
    this._logEntryEventController.stream.listen(_mapEventToState);
  }

  void fetchLogEntriesList({int pageNo, int projectId}) async {
    this.pageNo = pageNo;
    _logEntryListStateController
        .add(ApiResponse.loading(message: 'Page${this.pageNo}'));
    try {
      var result = await _logEntryRepository.fetchLogEntryList(
          pageNo: pageNo, projectId: projectId);
      logEntries = result.item1;
      noOfRecords = result.item2;
      logEntriesSelectedStatus = logEntries
              .map((currentLogEntry) => Tuple2(currentLogEntry, false))
              .toList();

      if (noOfRecords==0){
        _logEntryListStateController
                .add(ApiResponse.error('No records found'));
      }
      else{
        _logEntryListStateController
                .add(ApiResponse.completed(logEntriesSelectedStatus));
      }

    } catch (e) {
      if (e.runtimeType == SocketException) {
        _logEntryListStateController
            .add(ApiResponse.error('Connection Refused'));
      }
    }
  }

  void connectToRedis() async {
    final pubsub =
        await PubSub.connect<String, String>("redis://192.168.0.107:6379");
    pubsub.subscribe(channel: "onChat" + globals.authToken.split(" ")[1]);
    pubsub.stream.listen((data) {
      if (data.runtimeType.toString() == 'MessageEvent<String, String>') {
        this.logEntry = LogEntry.fromJson(json
            .decode((data as MessageEvent<String, String>).message.toString()));
        this.logEventControllerSink.add(NewLogEntryEvent());
      }
    });
  }

  void _mapEventToState(LogEntryEvent event) {
    if (event is NewLogEntryEvent) {
      // New issue event
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
    } else if (event is LogEntryCheckBoxToggledEvent) {
      // Log Entry List Item Selected
      var previousTuple = this.logEntriesSelectedStatus[event.index];
      this.logEntriesSelectedStatus[event.index] =
          Tuple2(previousTuple.item1, !previousTuple.item2);
      this.inIssue.add(ApiResponse.completed(this.logEntriesSelectedStatus));
    }
  }

  void dispose() {
    _logEntryEventController.close();
    _logEntryListStateController.close();
  }
}
