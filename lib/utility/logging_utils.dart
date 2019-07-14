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

const grey = Color(0xffb74093);
const green = Color(0x00FF00);
const blue = Color(0x0000FF);
const yellow = Color(0xFFFF00);
const red = Color(0xFF0000);
const orange = Color(0xFFA500);
const black = Color(0x000000);

var logLevelTuple = [
	[NOTSET, LEVEL_NOTSET, grey],
	[DEBUG, LEVEL_DEBUG, green],
	[INFO, LEVEL_INFO, blue],
	[WARNING, LEVEL_WARNING, yellow],
	[ERROR, LEVEL_ERROR, red],
	[FATAL, LEVEL_FATAL, orange],
	[CRITICAL, LEVEL_CRITICAL, black],
];


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
}

var notset = new LogLevel(level: LEVEL_NOTSET, name: NOTSET, color: grey);
var debug = new LogLevel(level: LEVEL_DEBUG, name: DEBUG, color: green);
var info = new LogLevel(level: LEVEL_INFO, name: INFO, color: blue);
var warning = new LogLevel(level: LEVEL_WARNING, name: WARNING, color: yellow);
var error = new LogLevel(level: LEVEL_ERROR, name: ERROR, color: red);
var fatal = new LogLevel(level: LEVEL_FATAL, name: FATAL, color: orange);
var critical = new LogLevel(level: LEVEL_CRITICAL, name: CRITICAL, color: black);
