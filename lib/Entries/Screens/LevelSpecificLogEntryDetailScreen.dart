import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/utility/LogLevel.dart';

class StackTraceFrameTile extends StatefulWidget {
  final int excetptionLineNo;
  final String fileName;
  final String functionName;
  final String preContextText;
  final String exceptionContextText;
  final String postContextText;

  const StackTraceFrameTile(
      {Key key,
      this.excetptionLineNo,
      this.fileName,
      this.functionName,
      this.preContextText,
      this.exceptionContextText,
      this.postContextText})
      : super(key: key);
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
    var completeLine =
        '${widget.fileName} in ${widget.functionName} at line ${widget.excetptionLineNo}';

    var textWidget = Expanded(
        child: Container(
      child: Text(
        completeLine,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      color: Color(0xececf1).withAlpha(0xFF),
      margin: EdgeInsets.all(4),
    ));

    var self = this;

    var plusMinusIcon = Icons.remove;
    if (collapsed) plusMinusIcon = Icons.add;

    var plusMinusButton = IconButton(
        onPressed: () {
          toggleCollapse();
        },
        icon: Container(
            decoration: new BoxDecoration(
                border: new Border.all(color: Colors.grey),
                color: Color(0xFFFFFF).withAlpha(0xFF)),
            child: Icon(
              plusMinusIcon,
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
              children: <Widget>[textWidget, plusMinusButton])),
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
              widget.preContextText,
              style: TextStyle(height: 1.2, fontSize: 15),
            ),
            Container(
              child: Text(
                widget.exceptionContextText,
                style:
                    TextStyle(color: Colors.white, height: 1.2, fontSize: 15),
              ),
              color: Color(0x6c5fc7).withAlpha(0xFFFFF),
              width: double.infinity,
            ),
            Text(widget.postContextText,
                style: TextStyle(height: 1.2, fontSize: 15))
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
    List<Widget> exceptionStackTracesTiles = [];
    if (widget.logEntry.stacktrace != null) {
      widget.logEntry.stacktrace['frames_data'].forEach((currentMap) {
        List<String> previousLines = [];
        List<String> nextLines = [];
        (currentMap['previous_lines'] as List<dynamic>).forEach((dynamic p) {
          previousLines.add(p);
        });
        (currentMap['next_lines'] as List<dynamic>).forEach((dynamic p) {
          nextLines.add(p);
        });
        exceptionStackTracesTiles.add(
          StackTraceFrameTile(
            functionName: currentMap['function_name'],
            excetptionLineNo: currentMap['line_no'],
            fileName: currentMap['filepath'],
            preContextText: previousLines.join(),
            exceptionContextText: currentMap['code_line'],
            postContextText: nextLines.join(),
          ),
        );
      });
    }

    List<Widget> frames = [
      //Message
      new Text(
        'Message:',
        style: TextStyle(fontSize: 22, color: Color.fromRGBO(127, 127, 127, 1)),
      ),
      new Text(
        widget.logEntry.message,
        style: TextStyle(fontSize: 20),
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
    ];

    if (exceptionStackTracesTiles.length != 0) {
      frames.addAll(exceptionStackTracesTiles);
    }
    frames.addAll([
      Padding(
        padding: EdgeInsets.all(4),
      ),

      Divider(
        color: Colors.grey[500],
      ),

      // Timestamp
      new Text(
        'Timestamp:',
        style: TextStyle(fontSize: 22, color: Color.fromRGBO(127, 127, 127, 1)),
      ),

      new Text(
        DateFormat("MMM d, y hh:mm:ss").format(widget.logEntry.createdAt),
        style: TextStyle(fontSize: 20),
      ),

      Divider(
        color: Colors.grey[500],
      ),

      new Text(
        'Tags:',
        style: TextStyle(fontSize: 22, color: Color.fromRGBO(127, 127, 127, 1)),
      ),

      new Builder(builder: (BuildContext context) {
        return GridView.count(
            primary: false, // set false to disallow scrolling inside grid view
            crossAxisCount: 2,
            mainAxisSpacing: 0.1,
            childAspectRatio: 3,
            shrinkWrap: true,
            children: widget.logEntry.tags.entries
                .map(
                  (mapEntry) => GridTile(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            mapEntry.key,
                            style: TextStyle(
                                fontSize: 22,
                                color: black,
                                backgroundColor: green),
                          ),
                          Text(" : ", style: TextStyle(fontSize: 22)),
                          Text(
                            mapEntry.value,
                            style: TextStyle(fontSize: 22, color: blue),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList());
      }),

      Divider(
        color: Colors.grey[500],
      ),
    ]);
    return new Container(
      child: ListView(
        shrinkWrap: true,
        children: frames,
      ),
    );
  }
}
