import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pro_logger/Entries/Events/issue_events.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:web_socket_channel/io.dart';

class LogEntryListBloc
{

    LogEntry logEntry = new LogEntry(id:null, title: null, message: null, logLevel: null, created_at:null);

    List<LogEntry> logEntries;
    LogEntryRepository _logEntryRepository;

    WebSocket _webSocket;
    IOWebSocketChannel _ioWebSocketChannel;

    StreamController<List<LogEntry>> _issueListStateController = StreamController<List<LogEntry>>();
//  https://stackoverflow.com/a/51397263/7698247
    StreamSink<List<LogEntry>> get inIssue => _issueListStateController.sink;
    Stream<List<LogEntry>> get logEntryStream => _issueListStateController.stream;


    final _logEntryEventController = StreamController<LogEntryEvent>();
    Sink<LogEntryEvent> get logEventControllerSink => _logEntryEventController.sink;


    LogEntryListBloc()
    {
        _logEntryRepository = new LogEntryRepository();
        fetchLogEntriesList();
        connectToSocket();
         _logEntryEventController.stream.listen(_mapEventToState);
    }


    void fetchLogEntriesList() async {
        logEntries = await _logEntryRepository.fetchLogEntryList();
        _issueListStateController.add(logEntries);
    }


    void connectToSocket() async
    {
        _webSocket = await WebSocket.connect("ws://192.168.0.107:8080/", protocols: ['echo-protocol']);
        _ioWebSocketChannel = IOWebSocketChannel(_webSocket);
        _ioWebSocketChannel.sink.add(json.encode({'type': 'onConnect'}));
        _ioWebSocketChannel.stream.listen((dynamic data){
            logEntry = LogEntry.fromJson(json.decode(data.toString()));
            logEventControllerSink.add(NewLogEntryEvent());
        });
    }


    void _mapEventToState(LogEntryEvent event)
    {
        if (event is NewLogEntryEvent)
        {
            logEntries.length+=1;
            logEntries.setRange(1,logEntries.length,logEntries);
            logEntries.setRange(0, 1, [logEntry]);
            inIssue.add(logEntries);
        }

//        _inIssue.add(logEntries);
    }

    void dispose()
    {
        _logEntryEventController.close();
        _issueListStateController.close();
        _ioWebSocketChannel.sink.close();
        _webSocket.close();

    }

}