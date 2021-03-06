import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_logger/Auth/Repositories/auth_repository.dart';
import 'package:pro_logger/Entries/widgets/loader.dart';
import 'package:pro_logger/common_widgets.dart';
import 'package:pro_logger/library_widgets/flutter_mobile_input.dart';
import 'package:sms/sms.dart';

final mobileInputWidgetStatekey = new GlobalKey<MobileInputState>();
final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);

class RegistrationScreenPartTwo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationScreenPartTwoState();
  }
}

class RegistrationScreenPartTwoState extends State<RegistrationScreenPartTwo> {
  EdgeInsetsGeometry commonPadding = EdgeInsets.only(left: 32);
  MobileInput mobileInputWidget;

  /// Currently Typed phone No.
  String phoneNo = '';

  /// Controller for TextField in [MobileInput] Widget.
  TextEditingController get controller {
    return mobileInputWidgetStatekey.currentState?.controller;
  }

  AuthRepository authRepository;
  @override
  void initState() {
    super.initState();
    mobileInputWidget = MobileInput(
      autofocus: true,
      key: mobileInputWidgetStatekey,
      onTextChanged: _handleOnTextChanged,
    );

    authRepository = AuthRepository();
  }

  void _handleNextPressed(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return Loader();
        });

    validateMobileNo(this.phoneNo).then((bool isValid) {
      if (!isValid) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return getInvalidMobileNoAlertDialog(buildContext);
            });
      } else {
        String phoneNo = this.phoneNo;
        String countryCode =
            '+' + mobileInputWidgetStatekey.currentState.country.dialCode;
        print("generating otp");
        authRepository.generateOtp(phoneNo: countryCode + phoneNo);
        print("going to next");
        Navigator.pushNamed(context, 'otpInputScreen', arguments: [
          this.phoneNo,
          mobileInputWidgetStatekey.currentState.country.dialCode
        ]);
      }
    });
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

  void _handleOnTextChanged(String phoneNo) {
    if ((phoneNo.length == 0 && this.phoneNo.length > 0) ||
        (phoneNo.length > 0 && this.phoneNo.length == 0)) {
      setState(() {
        this.phoneNo = phoneNo;
      });
    } else {
      this.phoneNo = phoneNo;
    }
  }

  Widget getInvalidMobileNoAlertDialog(BuildContext context) {
    return getAlertDialog(
        context: context,
        title: 'Invalid Mobile No.',
        description: 'Please enter Valid Mobile No',
        buttonText: 'OK',
        onTap: () {
          Navigator.of(context).pop();
          mobileInputWidgetStatekey.currentState.setFocusWithKeyboard();
        });
  }

  Future<bool> validateMobileNo(String value) async {
    bool result = await Future.delayed(Duration(seconds: 2), () {
      return true;
    });
    return result;
  }
}
