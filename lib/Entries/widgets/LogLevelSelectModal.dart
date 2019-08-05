import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro_logger/utility/LogLevel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogLevelSelectModalWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LogLevelSelectModalWidgetState();
  }
}

class LogLevelSelectModalWidgetState extends State<LogLevelSelectModalWidget> {
  Map<String, dynamic> checkboxStatuses = {};
//    NOTSET: true,
//    DEBUG: true,
//    INFO: true,
//    WARNING: true,
//    ERROR: true,
//    CRITICAL: true,
//    FATAL: true
//  };

  @override
  void initState() {
    super.initState();
    setLogLevelStates();
//  clearSharedPrefs();
  }

  List<Widget> getListOfCheckboxes() {
    List<Widget> checkBoxWidgetList = new List<Widget>();
    for (var i = 0; i < checkboxStatuses.keys.length; i++) {
      var levelName = checkboxStatuses.keys.toList()[i];
      checkBoxWidgetList.add(new CheckboxListTile(
        value: checkboxStatuses[levelName],
        title: Text(levelName),
        onChanged: (bool status) {
          setState(() {
            checkboxStatuses[levelName] = status;
          });
        },
      ));
    }
    return checkBoxWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Select Levels"),
      children: [
        Column(
          children: <Widget>[
            Column(
              children: getListOfCheckboxes(),
            ),
            Divider(),
            Padding(padding: EdgeInsets.only(top: 5.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    saveLogLevelSelectedStatesInSharedPrefs();
                    Navigator.of(context).pop();
                  },
                  textColor: Colors.white,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.green),
                    padding: const EdgeInsets.all(10.0),
                    child:
                        const Text('Confirm', style: TextStyle(fontSize: 20)),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  textColor: Colors.white,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.red),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text('Cancel', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  void saveLogLevelSelectedStatesInSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'LogLevelCheckboxStatuses', jsonEncode(this.checkboxStatuses));
  }

  void setLogLevelStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString('LogLevelCheckboxStatuses');
    if (result == null) {
      setState(() {
          checkboxStatuses = {
              NOTSET: true,
              DEBUG: true,
              INFO: true,
              WARNING: true,
              ERROR: true,
              CRITICAL: true,
              FATAL: true
          };
      });

      await prefs.setString(
          'LogLevelCheckboxStatuses', jsonEncode(this.checkboxStatuses));
    } else {
      setState(() {
        this.checkboxStatuses = jsonDecode(result);
      });
    }
  }

  void clearSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getKeys());
    prefs.clear();
  }
}
