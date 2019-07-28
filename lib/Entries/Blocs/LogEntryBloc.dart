import 'dart:async';
import 'dart:convert';
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

    StreamController<List<LogEntry>> _issueListStateController = StreamController<List<LogEntry>>();
    StreamSink<List<LogEntry>> get _inIssue => _issueListStateController.sink;
    Stream<List<LogEntry>> get logEntryStream => _issueListStateController.stream;


    final _issueEventController = StreamController<LogEntryEvent>();
    Sink<LogEntryEvent> get issueEventController => _issueEventController.sink;


    LogEntryBloc()
    {
        _logEntryRepository = new LogEntryRepository();
        fetchLogEntriesList();
        connectToSocket();
         _issueEventController.stream.listen(_mapEventToState);
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
//            addDataToList(data);
        });
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
        _ioWebSocketChannel.sink.close();
        _webSocket.close();

    }

}