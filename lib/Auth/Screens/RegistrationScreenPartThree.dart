import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pro_logger/Auth/Repositories/auth_repository.dart';
import 'package:pro_logger/Entries/widgets/loader.dart';
import 'package:pro_logger/common_widgets.dart';
import 'package:pro_logger/library_widgets/otp_field.dart';
import 'package:sms/sms.dart';

final otpFieldStateKey = new GlobalKey<OTPFieldState>();

class RegistrationScreenPartThree extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationScreenPartThreeState();
  }
}

class RegistrationScreenPartThreeState
    extends State<RegistrationScreenPartThree> {
  SmsReceiver receiver;

  StreamSubscription<SmsMessage> _streamSubscription;

  String otpValue = '';

  OTPField otpField;

  @override
  void initState() {
    super.initState();
    receiver = new SmsReceiver();
    _streamSubscription = receiver.onSmsReceived.listen((SmsMessage msg) {
      if (AuthRepository().checkAuthorizedSMS(msg)) {
        RegExp regExp = new RegExp("(\\d{4})");
        String receivedOTP = regExp.firstMatch(msg.body).group(0);
        print(receivedOTP);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool buttonEnabled = (otpValue.length == 4);
    this.otpField = OTPField(
      key: otpFieldStateKey,
      onOtpChanged: (String currentOtp) {
        setState(() {
          otpValue = currentOtp;
        });
      },
    );
    List phoneNoAndDialCode = ModalRoute.of(context).settings.arguments;
    String phoneNo = phoneNoAndDialCode[0];
    String dialCode = '+' + phoneNoAndDialCode[1];
    return Scaffold(
      body: Material(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 0.1 * MediaQuery.of(context).size.height,
            ),
            Container(
              child: Text(
                'Please wait.\nWe will auto verify\nthe OTP sent to\n$dialCode${phoneNo.toString()}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              padding: EdgeInsets.only(left: 40),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(
              height: 0.1 * MediaQuery.of(context).size.height,
            ),
            Container(
              padding: EdgeInsets.only(left: 40),
              alignment: Alignment.centerLeft,
              child: this.otpField,
            ),
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
                        ? () => _handleNextPressed(context, dialCode+phoneNo)
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  _handleNextPressed(BuildContext context, String phoneNo) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return Loader();
        });
    validateOtp(otpValue, phoneNo).then((bool isOtpValid) {
      Navigator.of(context).pop();
      if (!isOtpValid) {
        showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return getAlertDialog(
              context: buildContext,
              title: 'Invalid OTP',
              buttonText: 'OK',
              description: 'Please Enter Valid OTP',
              onTap: () {
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FocusScope.of(context)
                      .requestFocus(otpFieldStateKey.currentState.focusNode);
                });
              },
            );
          },
        );
      }
      else{
        Navigator.of(context).pushNamed('HomeScreen');
      }
    });
  }

  Future<bool> validateOtp(String otp, String phoneNo) async {
    bool result = await AuthRepository().validateOtp(phoneNo: phoneNo, otp: otp);
    return result;
  }
}
