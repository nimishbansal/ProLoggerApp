import 'dart:async';

import 'package:pro_logger/Entries/Events/issue_events.dart';
import 'package:pro_logger/LogEntry.dart';

class IssueBloc
{

    LogEntry logEntry;
    final _issueListStateController = StreamController<LogEntry>();
    final _issueEventController = StreamController<IssueEvent>();

    StreamSink<LogEntry> get _inIssue => _issueListStateController.sink;
    Stream<LogEntry> get issue => _issueListStateController.stream;

    Sink<IssueEvent> get issueEventController => _issueEventController.sink;

    IssueBloc()
    {
        _issueEventController.stream.listen(_mapEventToState);
    }


    void _mapEventToState(IssueEvent event)
    {
        if (event is NewIssueEvent)
        {

        }

        _inIssue.add(logEntry);
    }

    void dispose()
    {
        _issueEventController.close();
        _issueListStateController.close();

    }
}