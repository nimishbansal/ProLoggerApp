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
    var plus_button = IconButton(
        onPressed: () {
          super.setState(() => {collapsed = !(collapsed)});
        },
        icon: Container(
            decoration: new BoxDecoration(
                border: new Border.all(color: Colors.grey),
                color: Color(0xFFFFFF).withAlpha(0xFF)),
            child: Icon(
              Icons.add,
              color: Colors.grey,
            )));

    var group_text_widget_and_expand_button = Container(
        color: Color(0xececf1).withAlpha(0xFF),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[text_widget, plus_button]));

    var expanded_details;
    if (collapsed) {
      expanded_details = Container();
    } else {
      expanded_details = Container(
        child: Text(
            'def get_access_token(self):\nif((self.expiryTime-self.get_current_time_in_millis())>5000):\nreturn self.accessToken \nelse:\nraise ZohoOAuthException("Access token got expired!")\n@staticmethod\ndef get_current_time_in_millis():\nimport time\nreturn int(round(time.time() * 1000))\ndef set_user_email(self,userEmail):\n"),);'),
      );
    }
    var final_column = Column(
      children: <Widget>[group_text_widget_and_expand_button, expanded_details],
    );
    return final_column;
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
  @override
  Widget build(BuildContext context) {
    var x = StackTraceFrameTile();
    var y = StackTraceFrameTile();
    var z = StackTraceFrameTile();
    return SingleChildScrollView(child: Column(children: <Widget>[x,y,z],),);
  }
}
