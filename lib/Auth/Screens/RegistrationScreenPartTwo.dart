import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_logger/Entries/widgets/loader.dart';
import 'package:pro_logger/library_widgets/flutter_mobile_input.dart';

final mobileInputWidgetStatekey = new GlobalKey<MobileInputState>();

class RegistrationScreenPartTwo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationScreenPartTwoState();
  }
}

class RegistrationScreenPartTwoState extends State<RegistrationScreenPartTwo> {
  EdgeInsetsGeometry commonPadding = EdgeInsets.only(left: 32);
  MobileInput mobileInputWidget;
  String phoneNo = '';

  @override
  void initState() {
    super.initState();
    mobileInputWidget = MobileInput(
      autofocus: true,
      key: mobileInputWidgetStatekey,
      onTextChanged: (String phoneNo) {
        print("hmm");
        if ((phoneNo.length == 0 && this.phoneNo.length > 0) ||
            (phoneNo.length > 0 && this.phoneNo.length == 0)) {
          setState(() {
            this.phoneNo = phoneNo;
          });
        } else {
          this.phoneNo = phoneNo;
        }
      },
    );
  }

  TextEditingController get controller {
    return mobileInputWidgetStatekey.currentState?.controller;
  }

  void _handleNextPressed(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return Loader();
        });
    Future.delayed(
      Duration(seconds: 1),
      () {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext buildContext) {
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
                          'Invalid Mobile No.',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
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
                          'Please enter Valid Mobile No',
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
                            'OK',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Colors.yellowAccent, fontWeight: FontWeight.bold),
                          ),
                          width: 0.9 * MediaQuery.of(context).size.width,
                        ),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool buttonEnabled = (this.phoneNo.length != 0);
    return Scaffold(
      body: Material(
        child: Container(
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Back Button
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 36, color: Colors.black38),
                  onPressed: () {
                    SystemChannels.textInput
                        .invokeMethod('TextInput.hide')
                        .whenComplete(() {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pop();
                      });
                    });
                  },
                ),
              ),

              SizedBox(height: 0.06 * MediaQuery.of(context).size.height),

              //Title
              Container(
                padding: commonPadding,
                child: Text(
                  'Enter Phone number for\nverification',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 14),

              //Small Description
              Container(
                padding: commonPadding,
                child: Text(
                  'The number will be used to register you\nand comunicate all feature update details',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

              SizedBox(height: 0.05 * MediaQuery.of(context).size.height),

              //Mobile Input
              Container(
                padding: commonPadding,
                child: this.mobileInputWidget,
              ),

              // Next Button
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    //https://stackoverflow.com/a/52697978/7698247
                    color: buttonEnabled ? Colors.black : Colors.grey,
                    child: InkWell(
                      splashColor: Colors.white,
                      radius: 200,
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Next',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          width: 0.9 * MediaQuery.of(context).size.width),
                      onTap: buttonEnabled
                          ? () => _handleNextPressed(context)
                          : null,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
