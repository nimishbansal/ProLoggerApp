import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:pro_logger/Entries/Events/issue_events.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:pro_logger/LogEntry.dart';
import 'package:web_socket_channel/io.dart';

class LogEntryBloc
{

    List<LogEntry> logEntries;
    LogEntryRepository _logEntryRepository;

    WebSocket _webSocket;
    IOWebSocketChannel _ioWebSocketChannel;
    final _issueListStateController = StreamController<List<LogEntry>>();
    final _issueEventController = StreamController<LogEntryEvent>();

    StreamSink<List<LogEntry>> get _inIssue => _issueListStateController.sink;
    Stream<List<LogEntry>> get issue => _issueListStateController.stream;

    Sink<LogEntryEvent> get issueEventController => _issueEventController.sink;

    LogEntryBloc()
    {
        _logEntryRepository = new LogEntryRepository();
        fetchLogEntriesList();
        setSocketForRealtimeErrors();
        _issueEventController.stream.listen(_mapEventToState);
    }


    void fetchLogEntriesList() async {
        logEntries = await _logEntryRepository.fetchLogEntryList();
    }


    void setSocketForRealtimeErrors() async {
        _webSocket = await WebSocket.connect("ws://192.168.0.107:8080/", protocols: ['echo-protocol']);
        _ioWebSocketChannel = IOWebSocketChannel(_webSocket);
//        print("ouu");
//        print("stream is " + _ioWebSocketChannel.stream.toString());
//        _ioWebSocketChannel.stream.listen((dynamic data){
//            print("data is " + data.toString());
//        });
//        _ioWebSocketChannel.sink.add("message");
    }

    void _mapEventToState(LogEntryEvent event)
    {
        if (event is NewLogEntryEvent)
        {

        }

        _inIssue.add(logEntries);
    }

    void dispose()
    {
        _issueEventController.close();
        _issueListStateController.close();
//        _ioWebSocketChannel.sink.close();
//        _webSocket.close();

    }

}