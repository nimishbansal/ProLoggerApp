abstract class LogEntryEvent{}

class NewLogEntryEvent extends LogEntryEvent
{}

class LogEntryCheckBoxToggledEvent extends LogEntryEvent
{
    final index;
    LogEntryCheckBoxToggledEvent({this.index});
}