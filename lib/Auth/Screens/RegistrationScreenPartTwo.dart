import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void _handleNextPressed() {
    print('next button Pressed');
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
                    SystemChannels.textInput.invokeMethod('TextInput.hide').whenComplete((){
                      WidgetsBinding.instance.addPostFrameCallback((_){
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
                  child: GestureDetector(
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: buttonEnabled
                                ? Colors.black
                                : Colors.grey),
                        child: Text(
                          'Next',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        width: 0.9 * MediaQuery.of(context).size.width),
                    onTap: buttonEnabled?_handleNextPressed:null,
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
