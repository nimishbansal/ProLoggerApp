import 'package:flutter/material.dart';
import 'package:pro_logger/utility/LogLevel.dart';

class LogLevelSelectModalWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LogLevelSelectModalWidgetState();
  }
}

class LogLevelSelectModalWidgetState extends State<LogLevelSelectModalWidget> {
  var checkboxStatuses = {
    NOTSET: true,
    DEBUG: true,
    INFO: true,
    WARNING: true,
    ERROR: true,
    CRITICAL: true,
    FATAL: true
  };

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
    return new SimpleDialog(title: new Text("Selec Level"), children: getListOfCheckboxes());
  }
}
