import 'package:flutter/material.dart';

Widget getAlertDialog({@required BuildContext context,@required  String title,@required  String description,@required  String buttonText, @ required Function onTap}){
    return AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                    ),
                ),
                Divider(
                    thickness: 1,
                    color: Colors.grey,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            description,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                        ),
                    ),
                ),
                Padding(
                    padding: EdgeInsets.all(12),
                ),
                Material(
                    color: Colors.black,
                    elevation: 3,
                    child: InkWell(
                        child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                'Ok',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
//                                        fontWeight: FontWeight.bold,
                                ),
                            ),
                            width: 0.9 * MediaQuery.of(context).size.width,
                        ),
                        onTap: onTap,
                    ),
                ),
            ],
        ),
    );
}