abstract class IssueEvent{}

class NewIssueEvent extends IssueEvent
{}

class NotSetEvent extends NewIssueEvent
{}

class DebugEvent extends NewIssueEvent
{}

class InfoEvent extends NewIssueEvent
{}

class WarningEvent extends NewIssueEvent
{}

class ErrorEvent extends NewIssueEvent
{}

class FatalEvent extends NewIssueEvent
{}

class CriticalEvent extends NewIssueEvent
{}