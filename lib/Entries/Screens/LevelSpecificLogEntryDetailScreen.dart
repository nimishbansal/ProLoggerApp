import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/utility/LogLevel.dart';

class StackTraceFrameTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StackTraceFrameTileState();
  }
}

class StackTraceFrameTileState extends State<StackTraceFrameTile> {
  var collapsed = true;

  toggleCollapse() {
    this.setState(() {
      collapsed = !(collapsed);
    });
  }

  @override
  Widget build(BuildContext context) {
    var exception_line_no = 26;
    var file_name = "utility/zohocrm/zohocrm_leads.py";
    var function_name = "load_oauth_token_and_access_token_from_pickle";
    var complete_line =
        '$file_name in $function_name at line $exception_line_no';

    var text_widget = Expanded(
        child: Container(
      child: Text(
        complete_line,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      color: Color(0xececf1).withAlpha(0xFF),
      margin: EdgeInsets.all(4),
    ));

    var self = this;

    var plus_minus_icon = Icons.remove;
    if (collapsed) plus_minus_icon = Icons.add;

    var plus_minus_button = IconButton(
        onPressed: () {
          toggleCollapse();
        },
        icon: Container(
            decoration: new BoxDecoration(
                border: new Border.all(color: Colors.grey),
                color: Color(0xFFFFFF).withAlpha(0xFF)),
            child: Icon(
              plus_minus_icon,
              color: Colors.grey,
            )));

    var groupTextWidgetAndExpandButton = GestureDetector(
      child: Container(
          decoration: BoxDecoration(
              color: Color(0xececf1).withAlpha(0xFF),
              border: Border.all(width: 0.6, color: Colors.grey[500])),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[text_widget, plus_minus_button])),
      onTap: () {
        toggleCollapse();
      },
    );

    var preContextText =
        "\ndef sample(request):\n    a = 40\n    b = 50\n    print('hehehe')";
    var exceptionContextText = '    print(a/(b-50))';
    var postContextText =
        '    print("hahahah")\n    print(\'hohoho\')\n    return';

    var expandedDetails;
    if (collapsed) {
      expandedDetails = Container();
    } else {
      expandedDetails = Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              preContextText,
              style: TextStyle(height: 1.2, fontSize: 15),
            ),
            Container(
              child: Text(
                exceptionContextText,
                style:
                    TextStyle(color: Colors.white, height: 1.2, fontSize: 15),
              ),
              color: Color(0x6c5fc7).withAlpha(0xFFFFF),
              width: double.infinity,
            ),
            Text(postContextText, style: TextStyle(height: 1.2, fontSize: 15))
          ],
        ),
      );
    }
    var finalColumn = Column(
      children: <Widget>[groupTextWidgetAndExpandButton, expandedDetails],
    );
    return finalColumn;
  }
}

class ErrorDetailScreenContainer extends StatefulWidget {
  final LogEntry logEntry;

  const ErrorDetailScreenContainer({Key key, this.logEntry}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ErrorDetailScreenContainerState();
  }
}

class ErrorDetailScreenContainerState
    extends State<ErrorDetailScreenContainer> {
  refresh() {
    setState(() {
      print("refreshing");
    });
  }

  @override
  Widget build(BuildContext context) {
    var x = StackTraceFrameTile();
    var y = StackTraceFrameTile();
    var z = StackTraceFrameTile();

    var frames = [
      //Message
      new Text(
        'Message:',
        style: TextStyle(fontSize: 22, color: Color.fromRGBO(127, 127, 127, 1)),
      ),
      new Text(
        widget.logEntry.message,
        style: TextStyle(
                fontSize: 20
        ),
      ),
      Padding(
        padding: EdgeInsets.all(4),
      ),

      Divider(
        color: Colors.grey[500],
      ),

      // Exception Stack Trace
      Align(
        alignment: Alignment.centerLeft,
        child: new Text(
          'Exception:',
          style: TextStyle(
            fontSize: 22,
            color: Color.fromRGBO(127, 127, 127, 1),
          ),
        ),
      ),
      x,
      y,
      z,

      Padding(
        padding: EdgeInsets.all(4),
      ),

      Divider(
        color: Colors.grey[500],
      ),

      // Timestamp
      new Text(
        'TimeStamp:',
        style: TextStyle(fontSize: 22, color: Color.fromRGBO(127, 127, 127, 1)),
      ),

      new Text(
        DateFormat("MMM d, y hh:mm:ss").format(widget.logEntry.created_at),
        style: TextStyle(fontSize: 20),
      ),

      //End
    ];
    return new Container(
      child: ListView(
        shrinkWrap: true,
        children: frames,
      ),
    );
  }
}
