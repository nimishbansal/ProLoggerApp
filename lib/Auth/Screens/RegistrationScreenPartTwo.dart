import 'package:flutter/material.dart';
import 'package:pro_logger/library_widgets/flutter_mobile_input.dart';

class RegistrationScreenPartTwo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationScreenPartTwoState();
  }
}

class RegistrationScreenPartTwoState extends State<RegistrationScreenPartTwo> {
  EdgeInsetsGeometry commonPadding = EdgeInsets.only(left: 32);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 36,
                color: Colors.black38,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SizedBox(
            height: 0.06 * MediaQuery.of(context).size.height,
          ),
          Container(
            padding: commonPadding,
            child: Text(
              'Enter Phone number for\nverification',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Container(
            padding: commonPadding,
            child: Text(
              'The number will be used to register you\nand comunicate all feature update details',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 0.05 * MediaQuery.of(context).size.height,
          ),
          Container(
            padding: commonPadding,
            child: MobileInput(
              autofocus: true,
            ),
          ),
        ],
      ),
    );
  }
}
