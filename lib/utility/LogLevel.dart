import 'dart:ui';

import 'package:meta/meta.dart';

const int LEVEL_NOTSET = 0;
const int LEVEL_DEBUG = 10;
const int LEVEL_INFO = 20;
const int LEVEL_WARNING = 30;
const int LEVEL_ERROR = 40;
const int LEVEL_CRITICAL = 50;
const int LEVEL_FATAL = 50; //Critical and Fatal are conceptually the same

const String NOTSET = 'NOTSET';
const String DEBUG = 'DEBUG';
const String INFO = 'INFO';
const String WARNING = 'WARNING';
const String ERROR = 'ERROR';
const String CRITICAL = 'CRITICAL';
const String FATAL = 'FATAL';

var grey = Color(0x808080).withAlpha(0xFF);
var green = Color(0x00FF00).withAlpha(0xFF);
var blue = Color(0x0000FF).withAlpha(0xFF);
var yellow = Color(0xFFFF00).withAlpha(0xFF);
var red = Color(0xFF0000).withAlpha(0xFF);
var orange = Color(0xFFA500).withAlpha(0xFF);
var black = Color(0x000000).withAlpha(0xFF);
var white = Color(0xFFFFFF).withAlpha(0xFF);

var logLevelTuple = [
	[NOTSET, LEVEL_NOTSET, grey],
	[DEBUG, LEVEL_DEBUG, green],
	[INFO, LEVEL_INFO, blue],
	[WARNING, LEVEL_WARNING, yellow],
	[ERROR, LEVEL_ERROR, red],
	[FATAL, LEVEL_FATAL, orange],
	[CRITICAL, LEVEL_CRITICAL, black],
];

var logLevelDictionary = {
    NOTSET: [NOTSET, LEVEL_NOTSET, grey],
    DEBUG: [DEBUG, LEVEL_DEBUG, green],
    INFO:[INFO, LEVEL_INFO, blue],
    WARNING:[WARNING, LEVEL_WARNING, yellow],
    ERROR: [ERROR, LEVEL_ERROR, red],
    FATAL: [FATAL, LEVEL_FATAL, orange],
    CRITICAL: [CRITICAL, LEVEL_CRITICAL, black],
};


class LogLevel
{
	int level;
	String name;
	Color color;

	LogLevel({@required int level, @required String name ,@required Color color})
	{
		this.level = level;
		this.name = name;
		this.color = color;
	}

	LogLevel.fromLevelName(String level_name)
	{
	    List<dynamic> args = logLevelDictionary[level_name];
        name=args[0];
        level=args[1];
        color=args[2];
	}
}

var notset = new LogLevel(level: LEVEL_NOTSET, name: NOTSET, color: grey);
var debug = new LogLevel(level: LEVEL_DEBUG, name: DEBUG, color: green);
var info = new LogLevel(level: LEVEL_INFO, name: INFO, color: blue);
var warning = new LogLevel(level: LEVEL_WARNING, name: WARNING, color: yellow);
var error = new LogLevel(level: LEVEL_ERROR, name: ERROR, color: red);
var fatal = new LogLevel(level: LEVEL_FATAL, name: FATAL, color: orange);
var critical = new LogLevel(level: LEVEL_CRITICAL, name: CRITICAL, color: black);
