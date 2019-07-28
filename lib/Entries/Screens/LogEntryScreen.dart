import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:pro_logger/LogEntry.dart';
import 'package:pro_logger/main.dart';
import 'package:pro_logger/widgets/LogEntryCard.dart';
import 'package:web_socket_channel/io.dart';

class LogEntryScreen extends StatefulWidget {
    final String title;
    LogEntryScreen({Key key, this.title}) : super(key: key);

    @override
    _LogEntryScreenState createState() => _LogEntryScreenState();
}

class _LogEntryScreenState extends State<LogEntryScreen> {

    var logEntries = List<LogEntry>();
    var dataLoaded = false;


    void addDataToList(dynamic data)
    {
        setState(() {
            logEntries.length+=1;
//            print(logEntries);
//            logEntries.setRange(1,logEntries.length,logEntries);
//            print(logEntries);
//            logEntries.setRange(0, 1, [LogEntry.fromJson(json.decode(data.toString()))]);
//            print(logEntries);
//            logEntries.length+=1;
//            print("logEntry length is ${logEntries.length}");
            for (int i=logEntries.length-1; i>0; i--)
            {
                logEntries[i] = logEntries[i-1];
            }
            logEntries[0] = LogEntry.fromJson(json.decode(data.toString()));
//            print("log entries are $logEntries");
//            logEntries.clear();


        });
    }

    void connectToSocket() async
    {
        var ws = await WebSocket.connect("ws://192.168.0.107:8080/", protocols: ['echo-protocol']);
        var s = IOWebSocketChannel(ws);
        s.sink.add("aww");
        s.stream.listen((dynamic data){
            addDataToList(data);
        });
    }


    @override
    void initState() {
        super.initState();
        LogEntryRepository repository = new LogEntryRepository();
        getLogEntries(repository);
        connectToSocket();
    }

    void getLogEntries(LogEntryRepository repository) async
    {
        var entries = await repository.fetchLogEntryList();
        setState((){
            logEntries.addAll(entries);
        });
    }


    @override
    Widget build (BuildContext context)
    {
        const List<Choice> choices = const <Choice>[
            const Choice(title: 'Car', icon: Icons.directions_car),
            const Choice(title: 'Bicycle', icon: Icons.directions_bike),
            const Choice(title: 'Boat', icon: Icons.directions_boat)
        ];
        return Scaffold(
            appBar: AppBar(
                leading: IconButton(icon:Icon(Icons.arrow_back_ios), onPressed: () {},),
                title: Text("Issues"),
                actions: <Widget>[
                    Builder(builder: (context) =>
                            PopupMenuButton<Choice>(
                                onSelected: (choice) => _select(choice, context),
                                itemBuilder: (BuildContext context) {
                                    return choices.map((Choice choice) {
                                        return PopupMenuItem<Choice>(
                                            value: choice,
                                            child: Text(choice.title),
                                        );
                                    }).toList();
                                },
                            ),
                    ),
                ],
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Container(child: _myListView(context), height:  MediaQuery.of(context).size.height-100,)
                    ],
                ),
            ),
        );
    }


    Widget _myListView(BuildContext context) {
        return ListView.builder(
            itemCount: logEntries.length,
            itemBuilder: (context, index) {
                print("logEntries $logEntries with index $index");
                return LogEntryCard(key:ValueKey(logEntries[index]), logEntry: logEntries[index],);
            },
        );

    }


    void _select(Choice value, BuildContext context) {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text(value.title + " selected"),
        ));
    }


}
