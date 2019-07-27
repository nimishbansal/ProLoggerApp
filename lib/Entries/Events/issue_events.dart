abstract class LogEntryEvent{}

class NewLogEntryEvent extends LogEntryEvent
{}

class NotSetEvent extends NewLogEntryEvent
{}

class DebugEvent extends NewLogEntryEvent
{}

class InfoEvent extends NewLogEntryEvent
{}

class WarningEvent extends NewLogEntryEvent
{}

class ErrorEvent extends NewLogEntryEvent
{}

class FatalEvent extends NewLogEntryEvent
{}

class CriticalEvent extends NewLogEntryEvent
{}