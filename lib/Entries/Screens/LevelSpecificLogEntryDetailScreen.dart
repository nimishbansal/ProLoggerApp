import 'package:flutter/material.dart';
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
      child: Text(complete_line),
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
          color: Color(0xececf1).withAlpha(0xFF),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[text_widget, plus_minus_button])),
      onTap: () {
        toggleCollapse();
      },
    );

    var expandedDetails;
    if (collapsed) {
      expandedDetails = Container();
    } else {
      expandedDetails = Container(
        child: Text(
            'def get_access_token(self):\nif((self.expiryTime-self.get_current_time_in_millis())>5000):\nreturn self.accessToken \nelse:\nraise ZohoOAuthException("Access token got expired!")\n@staticmethod\ndef get_current_time_in_millis():\nimport time\nreturn int(round(time.time() * 1000))\ndef set_user_email(self,userEmail):\n"),);'),
      );
    }
    var finalColumn = Column(
      children: <Widget>[groupTextWidgetAndExpandButton, expandedDetails],
    );
    return finalColumn;
  }
}

class ErrorDetailScreenContainer extends StatefulWidget {
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

    var frames = [x, y, z];
    return ListView(
      children: frames,
    );
  }
}
